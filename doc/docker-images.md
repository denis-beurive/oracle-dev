List all images:

```
docker images
```

Inspect the image:

```
docker inspect oracle-8-dev
docker inspect oracle-8-dev | jq ".[0].Config"
docker inspect oracle-8-dev | jq ".[0].Config.Cmd"
docker inspect oracle-8-dev | jq ".[0].Config.ExposedPorts"
```
