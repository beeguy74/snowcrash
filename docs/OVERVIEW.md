# SnowCrash - Penetration Testing CTF Challenge Guide

## Running with Docker

This project can be run inside a Docker container using the provided `Dockerfile` and `docker-compose.yml` files. This is the recommended way to run the project as it provides a consistent and isolated environment.

### Prerequisites

- Docker
- Docker Compose

### Building the Docker image

To build the Docker image, run the following command from the root of the project:

```bash
docker-compose build
```

### Running the container

To run the container, you need to provide the `SnowCrash.iso` file. The path to the iso file should be updated in the `docker-compose.yml` file.

Once you have updated the `docker-compose.yml` file, you can run the container with the following command:

```bash
docker-compose up -d
```

This will start the SnowCrash VM in a detached container. You can then access the VM by ssh into the container. The ssh port is forwarded to port 5555 on the host.

```bash
ssh user@localhost -p 5555
```

