```dos
docker run --detach ^
           --net=bridge ^
           --publish 1521:1521 ^
           --env ORACLE_PASSWORD=1234 ^
           --volume oracle-volume:/opt/oracle/oradata ^
           gvenzl/oracle-xe
```
