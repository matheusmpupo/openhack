FROM ubuntu:26.04

LABEL org.opencontainers.image.title="openhack" \
      org.opencontainers.image.description="Interactive sandbox with zsh, Node (nvm), pnpm and OpenCode"

# ---------- Global arguments ----------
ARG USERNAME=openhack
ARG NVM_VERSION=v0.40.8
ARG NODE_VERSION="lts/*"
ARG OPENCODE_VERSION=latest
ARG DEBIAN_FRONTEND=noninteractive

# ---------- Exit when any command fail ----------
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
        ca-certificates curl git jq sudo vim zsh \
        dnsutils iproute2 iputils-ping net-tools \
        libatomic1 \
    && rm -rf /var/lib/apt/lists/*

# ---------- Rename Ubuntu user ----------
RUN usermod -l "${USERNAME}" ubuntu \
    && usermod -d "/home/${USERNAME}" -m "${USERNAME}" \
    && groupmod -n "${USERNAME}" ubuntu \
    && chsh -s /usr/bin/zsh "${USERNAME}" \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
    && chmod 0440 "/etc/sudoers.d/${USERNAME}"

# ---------- Copy files from root to docker ----------
RUN mkdir -p "/usr/local/share/${USERNAME}"
COPY --chmod=644 docker/env.sh        /usr/local/share/"${USERNAME}"/env.sh
COPY --chmod=755 docker/entrypoint.sh /usr/local/bin/docker-entrypoint

# ---------- Create user from composer configuration ----------
USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV HOME=/home/${USERNAME} \
    SHELL=/usr/bin/zsh

# ---------- nvm, npm and pnpm installation ----------
RUN curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash \
    && . "/usr/local/share/${USERNAME}/env.sh" \
    && nvm install "${NODE_VERSION}" \
    && nvm alias default "${NODE_VERSION}" \
    && npm install -g "opencode-ai@${OPENCODE_VERSION}" pnpm

# ---------- oh-my-zsh installation and source ----------
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -s -- --unattended \
    && echo '. /usr/local/share/${USERNAME}/env.sh' >> ~/.zshrc

# ---------- Create opencode and pnpm configuration ----------
RUN mkdir -p ~/.config/opencode ~/.local/share/opencode ~/.local/share/pnpm

# ---------- Set entrypoint script ----------
ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["zsh"]
