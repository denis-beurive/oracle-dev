# Containers

Display the current container and schema:

```sql
select SYS_CONTEXT('userenv','con_name') "container name",
       SYS_CONTEXT('userenv','con_id') "container id",
       SYS_CONTEXT('userenv','CURRENT_SCHEMA') "Current schema",
       SYS_CONTEXT('userenv','SID') "SID"
FROM DUAL;
```

Display the list of containers:

```sql
SELECT CON_ID, NAME FROM V$CONTAINERS;
```

# Tablespaces

Create a tablespace inside a given container (here, the container is `XEPDB1`):

```sql
alter session set container = XEPDB1;
CREATE USER CONCERTO IDENTIFIED BY "password"
       DEFAULT TABLESPACE CONCERTO_DATA
       TEMPORARY TABLESPACE temp;
```

> If you forget the first request, then the tablespace is created into the "CDB".

Display the tablespaces:

```sql
SELECT TABLESPACE_NAME, STATUS, CONTENTS FROM dba_tablespaces;
```

Dipslay the users' default tablespaces:

```sql
select username, default_tablespace from dba_users;
select username, default_tablespace from dba_users where username = 'My_USER';
```

Delete a tablespace:

```sql
DROP TABLESPACE CONCERTO_DATA INCLUDING CONTENTS AND DATAFILES;
```

ALTER DATABASE DATAFILE concerto_data.dbf OFFLINE DROP;

# Session

Display the active sessions:

```sql
SELECT sid, serial#, status, username FROM v$session WHERE STATUS='ACTIVE' AND USERNAME IS NOT NULL;
```

