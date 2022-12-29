# Oracle XE 21c on a Docker container

This repository contains an Oracle development environment in the form of 2 Docker containers.

* One container holds an Oracle Linux 8 OS, with all the necessary tools for C programing, and SSH enabled access. It can be used to build applications for Oracle.
* The other container holds an Oracle XE 21c database. It can be used to test the applications built on the development environment.

# Oracle Linux 8 OS with all the necessary tools for C programing

## Building the image

```bash
docker build --tag oracle-8-dev --file Dockerfile.dev .
```

## Starting a container

```bash
docker run --detach --interactive --tty --rm \
       --publish 2222:22/tcp \
       oracle-8-dev
```

## Connecting to the container

The OS is configured with 2 UNIX users:

| user               | password           |
|--------------------|--------------------|
| `root`             | `root`             |
| `dev`              | `dev`              |

SSH connexions using the provided private key [data/private.key](data/private.key):

```bash
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 dev@localhost
```

> Make sure that the private key file has the right permission (`chmod 600 data/private.key`).
>
> You may need to clean the host SSH configuration: `ssh-keygen -f "/home/denis/.ssh/known_hosts" -R "[localhost]:2222"`

SSH connexions using UNIX password:

```bash
ssh -o IdentitiesOnly=yes -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -p 2222 dev@localhost
```

## Stop the container

```bash
docker ps --filter="ancestor=oracle-8-dev"
docker stop <container id>
```

# Docker notes

List the containers:

```bash
docker images
``` 

Get the list of running containers:

```bash
docker ps
```

Do not start the Docker service at startup:

```bash
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

# links

https://hub.docker.com/r/gvenzl/oracle-xe