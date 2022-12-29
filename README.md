# Oracle XE 21c on a Docker container

This repository contains 2 Dockerfiles.
* `Dockerfiles.dev`: defines an image that contains all the developer tools (Oracle Linux 8 with SSH access enabled).
* `Dockerfiles.db`: defines an image that contains the Oracle XE 21c database (Oracle Linux 8 with Oracle XE 21c).

## Database configuration

The configuration file `/etc/sysconfig/oracle-xe-21c.conf` contains the following configuration:

```
LISTENER_PORT=1521
EM_EXPRESS_PORT=5550
```

The `root` password for the database is "`root`".

# Building the images

## Building the database container

First, download the RPM that performs the installation of Oracle XE 21c [https://www.oracle.com/database/technologies/xe-downloads.html](here). Click on the link "_Oracle Database 21c Express Edition for Linux x64 ( OL8 )_". You will dowload the file "`oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm`". Store this file in the sub-directory [data](data).

Then execute the command below:

```bash
docker build --tag oracle-8-db --file Dockerfile.db .
```

> Documentation: [docker build](https://docs.docker.com/engine/reference/commandline/build/).

Please, pay attention to the information printed at the end of the installation process (the actual text _will_ differ):

```
Database creation complete. For details check the logfiles at:
 /opt/oracle/cfgtoollogs/dbca/XE.
Database Information:
Global Database Name:XE
System Identifier(SID):XE
Look at the log file "/opt/oracle/cfgtoollogs/dbca/XE/XE.log" for further details.

Connect to Oracle Database using one of the connect strings:
     Pluggable database: 09bdd15e5f01/XEPDB1
     Multitenant container database: 09bdd15e5f01
Use https://localhost:5550/em to access Oracle Enterprise Manager for Oracle Database XE
```

## Building the developer environment container

Execute the command below:

```bash
docker build --tag oracle-8-dev --file Dockerfile.dev .
```

# Run a new container

Documentation: [docker run](https://docs.docker.com/engine/reference/commandline/run/).

* `--detach`: run container in background and print container ID.
* `--interactive`: keep STDIN open even if not attached.
* `--tty`: allocate a pseudo-TTY.
* `--rm`: automatically remove the container when it exits.
* `--publish`: publish a container's port(s) to the host.

## Start the database container

Execute the command below:

```bash
docker run --detach --interactive --tty --rm \
       --publish 1521:1521/tcp \
       --publish 5550:5550/tcp \
       oracle-8-db
```

## Start the the developer environment container

Execute the command below:

```bash
docker run --detach --interactive --tty --rm \
       --publish 2222:22/tcp \
       oracle-8-dev
```

The OS is configured with 3 UNIX users:

* `root` (password "`root`").
* `dev` (password "`dev`").

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

# Stop a container

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

# links

Documentation: [here](https://docs.oracle.com/en/database/oracle/oracle-database/21/xeinl/starting-and-stopping-oracle-database.html)

https://hub.docker.com/r/gvenzl/oracle-xe