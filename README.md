# Self-hosted GitHub actions runner cluster IAC templates 
Collection of hands-off easy to configure github action runner clusters for a variety of project types.

## Disclaimer
The standard approach to deploying many runners for github actions is using [Kubernetes ARC](https://github.com/actions/actions-runner-controller). 
Unfortunately running docker containers from within CI in order to test some otherwise not available components is hasslefull within kubernetes. 
Both [docker-in-docker](https://github.com/jpetazzo/dind) and docker socket volume passthrough have inconveniences of their own.

I chose docker socket passthrough as its more reliable.

Thats why some examples require passing through docker engine from the host system, 
so siblings can be created from within a container. 
```yaml
volumes:
  - /usr/bin/docker:/usr/bin/docker
  - /var/run/docker.sock:/var/run/docker.sock
``` 

Example docker containers required in some workflows:
- [game-ci](https://github.com/game-ci/docker/)

## Structure

- `controlplane/`: Contains the source code of the control plane used to created github runners automatically for you.
- `examples/`: Contains directories for different project scenarios, each with its own `docker-compose.yml`, `.env.example`, `runner.flake`, and additional configuration files.
- `scripts/`: Contains utility scripts for managing the setup and automation of runner tokens.


## Getting Started

1. Clone this repository onto the machine intented for running a cluster.
2. Navigate to the desired project scenario in the `examples/` directory.
3. Copy `.env.example` to `.env` and fill in the required secrets.
4. Run `docker-compose up -d` to start the cluster.

### Examples

#### Unity CI/CD Pipeline

Configuration for a Unity CI/CD pipeline.

```sh
cd examples/unity-cd-pipeline
cp .env.example .env
# Fill in the .env file with the necessary secrets
docker-compose up -d
```
