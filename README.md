# Oracle XE 21c on a Docker container

This repository contains a Dockerfile that creates an image that provides the following environment:

* Oracle Linux 8 with SSH access enabled.
* All the tools required for C programming.
* Oracle XE 21c database.

The configuration file `/etc/sysconfig/oracle-xe-21c.conf` contains the following configuration:

```
LISTENER_PORT=1521
EM_EXPRESS_PORT=5550
```

The `root` password for the database is "`root`".

# Building the image

First, download the RPM that performs the installation of Oracle XE 21c [https://www.oracle.com/database/technologies/xe-downloads.html](here). Click on the link "_Oracle Database 21c Express Edition for Linux x64 ( OL8 )_". You will dowload the file "`oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm`". Store this file in the sub-directory [data](data).

Then execute the command below:

```bash
docker build --tag oracle-8 .
```

> Documentation: [docker build](https://docs.docker.com/engine/reference/commandline/build/).

# Run a new container

Execute the command below:

```bash
docker run --detach --interactive --tty --rm \
       --publish 2222:22/tcp \
       --publish 1521:1521/tcp \
       --publish 5550:5550/tcp \
       oracle-8
```

> Documentation: [docker run](https://docs.docker.com/engine/reference/commandline/run/).
>
> * `--detach`: run container in background and print container ID.
> * `--interactive`: keep STDIN open even if not attached.
> * `--tty`: allocate a pseudo-TTY.
> * `--rm`: automatically remove the container when it exits.
> * `--publish`: publish a container's port(s) to the host.

# Connecting to the container

The OS is configured with 3 UNIX users:

* `root` (password "`root`").
* `dev` (password "`dev`").
* `oracle` (password "`oracle`").

SSH connexions using the provided private key [data/private.key](data/private.key):

```bash
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 dev@localhost
ssh -o IdentitiesOnly=yes -o IdentityFile=data/private.key -p 2222 oracle@localhost
```

> Make sure that the private key file has the right permission (`chmod 600 data/private.key`).
>
> You may need to clean the host SSH configuration: `ssh-keygen -f "/home/denis/.ssh/known_hosts" -R "[localhost]:2222"`

SSH connexions using UNIX password:

```bash
ssh -o IdentitiesOnly=yes -p 2222 root@localhost
ssh -o IdentitiesOnly=yes -p 2222 dev@localhost
ssh -o IdentitiesOnly=yes -p 2222 oracle@localhost
```

# Stop the container

First, find the container's ID. Then stop it.

```bash
docker ps --filter="ancestor=oracle-8"
docker stop 1d279bd978ad
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
