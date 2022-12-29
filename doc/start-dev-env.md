```dos
docker run --detach ^
           --net=bridge ^
           --interactive ^
           --tty ^
           --rm ^
           --publish 2222:22/tcp ^
           --publish 7777:7777/tcp ^
           oracle-8-dev
```
