<h1 align="center">
  <img src="static/openhack-logo.png" alt="openhack" width="250px">
  <br>
</h1>

<p align="center">
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-_red.svg"></a>
</p>

<p align="center">
  <a href="#requirements">Requirements</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#usage">Usage</a>
</p>

Dockerized sandbox for running OpenCode AI agents on your own tools and files for security research. Host folders are mounted into the container, while the agent stays isolated from the rest of your system.

# Requirements

1. Install docker: [Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
2. Install docker compose: [compose-plugin](https://docs.docker.com/compose/install/linux/#install-using-the-repository)
3. Clone this repository

# Configuration

Clone this repository and modify mounted volumes in:
1. `.env`
2. `compose.yaml` volumes attribute

### WSL

If running on WSL, modify `networkingMode` to reach models and skills running on Windows, e.g.: ollama, burp or caido skills, etc.

Create `C:\Users\<username>\.wslconfig` and add:
```ini
[wsl2]
networkingMode=mirrored
```

# Usage

The commands below are a guide on how to use the docker/compose CLI.

| Command                                            | Description                                        |
|----------------------------------------------------|----------------------------------------------------|
| `docker compose build`                             | Build the container                                |
| `docker compose run --name openhack openhack`      | Create a persistent container named `openhack`     |
| `docker start -ai openhack`                        | Reattach to an existing container                  |
| `docker rm openhack`                               | Delete the container                               |
