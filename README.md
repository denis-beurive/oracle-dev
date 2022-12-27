

## Install Oracle Express on Docker


Download: https://www.oracle.com/database/technologies/xe-downloads.html

> `docker search oraclelinux-8`

Build the container:

```bash
docker build -t oracle-8 .
```

List the containers:

```bash
docker images
``` 

Run the container:

```bash
docker run --detach -it --rm -p 2222:22/tcp oracle-8
```

Get the list of running containers:

```bash
docker ps
```

Stop the container:

```bash
docker ps --filter="ancestor=oracle-8"
docker stop 1d279bd978ad
```

```
ssh -o IdentitiesOnly=yes -p 2222 root@localhost
```

## Notes about Ubuntu

Do not start the Docker service at startup:

```bash
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```


