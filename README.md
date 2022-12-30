# Oracle XE 21c development environment

This repository contains an Oracle development environment in the form of an image.

This image contains an Oracle Linux 8 installation, with all the necessary tools for C programing, and SSH enabled access. It can be used to build applications for Oracle.

# Building the image

```bash
docker build --tag oracle-8-dev --file Dockerfile.dev .
```

> [Related commands](doc/docker-images.md)

# Create a container and start it

```bash
docker run --detach \
           --net=bridge \
           --interactive \
           --tty \
           --rm \
           --publish 2222:22/tcp \
           --publish 7777:7777/tcp \
           oracle-8-dev
```

> MS-DOS: [here](doc/start-dev-env.md)
>
> [Related commands](doc/docker-containers.md)

# Connecting to the container

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

# Stop the container

```bash
docker ps --filter="ancestor=oracle-8-dev"
docker stop <container id>
```

# Oracle XE 21c database

## Getting the image

```bash
docker pull gvenzl/oracle-xe:latest
docker images
``` 

## Start the database

```bash
docker run --detach \
           --net=bridge \
           --publish 1521:1521 \
           --env ORACLE_PASSWORD=1234 \
           --volume oracle-volume:/opt/oracle/oradata \
           gvenzl/oracle-xe
```

> MS-DOS: [here](doc/start-db.md)
>
> [Related commands](doc/docker-containers.md)

## Connect to the database

We will use the container that runs the development environment (image `oracle-8-dev`) to connect to the database (that runs on the other container, which image is `gvenzl/oracle-xe`).

```bash
$ docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED       STATUS       PORTS                                       NAMES
32b79811e097   oracle-8-dev       "/usr/sbin/sshd -D"      3 hours ago   Up 3 hours   0.0.0.0:2222->22/tcp, :::2222->22/tcp       hungry_sinoussi
d0b3165c854e   gvenzl/oracle-xe   "container-entrypoin…"   3 hours ago   Up 3 hours   0.0.0.0:1521->1521/tcp, :::1521->1521/tcp   my-database
```

Get the IP addresses of the containers:

```bash
$ docker ps
CONTAINER ID   IMAGE              COMMAND                  CREATED       STATUS       PORTS                                       NAMES
32b79811e097   oracle-8-dev       "/usr/sbin/sshd -D"      3 hours ago   Up 3 hours   0.0.0.0:2222->22/tcp, :::2222->22/tcp       hungry_sinoussi
d0b3165c854e   gvenzl/oracle-xe   "container-entrypoin…"   3 hours ago   Up 3 hours   0.0.0.0:1521->1521/tcp, :::1521->1521/tcp   my-database
$ docker inspect 32b79811e097 | jq ".[0].NetworkSettings.IPAddress"
"172.17.0.3"
$ docker inspect d0b3165c854e | jq ".[0].NetworkSettings.IPAddress"
"172.17.0.2"
```

> JQ: [https://stedolan.github.io/jq/download/](https://stedolan.github.io/jq/download/)

Here:
* the container that runs the development environment has the IP address `172.17.0.3`.
* the container that runs the database has the IP address `172.17.0.2`.

Now, connect to the container that runs the development environment (using SSH), and execute the following command:

```bash
DB_HOST="172.17.0.2"
sqlplus system/1234@//${DB_HOST}/XEPDB1
```

It works !

# CLION configuration

Open:

`File` -> `Settings...` -> `Build, Execution, Deployment` -> `Toolchains`

Create a new toolchain with the type "Remote host", as shown below:

![](doc/docker-settings-toolchains.png)

> As you can see, we changed the default path to CMAKE, in order to use a newer version of the tool.
> The version of CMAKE installed by default on Oracle Linux 8 is "`3.20.2`". While this version is OK,
> we prefer to use a more recent one. At the time of writing CLION supports, at most, the version
> "`3.24.3`" of CMAKE. This is precisely the version that has been compiled and installed on the image.
> Please note that the new (compiled) version of CMAKE is intalled under `/usr/local/bin` (the original 
> one is installed under `/usr/bin`).

And configure the SSH connection:

![](doc/docker-settings-ssh-config.png)

> We chose to use the private key. But it is possible to use the login and the password.

Open:

`File` -> `Settings...` -> `Build, Execution, Deployment` -> `CMake`

Create a new profile (here "Remote debug"). Make sure to select the toolchain we've configured previously ("Docker for Oracle").

![](doc/cmake-settings.png)

If the configuration is OK, then you should get the following status in the CMake toolbar:

```
/usr/local/bin/cmake -DCMAKE_BUILD_TYPE=Debug -S /tmp/tmp.Y1gRPS40ZU -B /tmp/tmp.Y1gRPS40ZU/cmake-build-debug-remote
-- The C compiler identification is GNU 8.5.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /tmp/tmp.Y1gRPS40ZU/cmake-build-debug-remote

[Finished]
```

# Docker notes

Search for an image:

```bash
$ docker search gvenzl/oracle
NAME               DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
gvenzl/oracle-xe   Oracle Database XE (21c, 18c, 11g) for every…   145                  
```

List the images:

```bash
docker images
``` 

Delete an image:

```bash
docker image rm <image id>
```

List all dangling images:

```bash
docker images --filter "dangling=true"
```

> A dangling image just means that you've created the new build of the image, but it wasn't given a 
> new name. So the old images you have becomes the "dangling image" ((source)[https://stackoverflow.com/questions/45142528/what-is-a-dangling-image-and-what-is-an-unused-image]). 

Remove all dangling images:

```bash
docker image prune
```

Remove all dangling and unused images:

```bash
docker image prune -a
```

Inspect an image:

```bash
docker inspect <image id>
```

Inspect a container:

```bash
docker inspect <container id>
```

Get the list of running containers:

```bash
docker ps
```

Get the list of all containers (including the ones that are stoped):

```bash
docker ps --all
```

Delete a container:

```bash
docker rm <container id>
```

Do not start the Docker service at startup:

```bash
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

# links

* Extra RPM: [https://yum.oracle.com/repo/OracleLinux/OL8/developer/EPEL/x86_64/index.html](https://yum.oracle.com/repo/OracleLinux/OL8/developer/EPEL/x86_64/index.html)



