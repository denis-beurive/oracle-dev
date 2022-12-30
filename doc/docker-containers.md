List all running containers:

```
docker ps
docker ps --filter="ancestor=oracle-8-dev"
```

Inspect a container:

```
docker inspect <container id>
docker inspect f03f5b460e19 | jq ".[0].NetworkSettings.Ports"
docker inspect f03f5b460e19 | jq ".[0].NetworkSettings.IPAddress"
docker inspect f03f5b460e19 | jq ".[0].NetworkSettings.Networks.bridge.IPAddress"
```

Rename the container:

```
docker rename f03f5b460e19 oracle-env
```
