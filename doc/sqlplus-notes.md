# Notes about SQLPLUS

## Windows installation

You need:

* [Basic Instant Client Package](https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html). This will install some DLL (like the OCI DLL - Oracle Call Interface).
* [SQL\*Plus Instant Client Package](https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html).

> See [Instant Client Packages](https://www.oracle.com/database/technologies/instant-client.html)
>
> Download page: [Oracle Instant Client Downloads](https://www.oracle.com/database/technologies/instant-client/downloads.html)

Download the 2 packages. For example (at the time of writing, for a Windows 64-bit architecture):

* [instantclient-basic-windows.x64-21.8.0.0.0dbru.zip](https://download.oracle.com/otn_software/nt/instantclient/218000/instantclient-basic-windows.x64-21.8.0.0.0dbru.zip)
* [instantclient-sqlplus-windows.x64-21.8.0.0.0dbru.zip](https://download.oracle.com/otn_software/nt/instantclient/218000/instantclient-sqlplus-windows.x64-21.8.0.0.0dbru.zip)

> Check [this link](https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html) for updates.

Unzip the packages. The 2 packages will be unziped in the same directory (ex: "`instantclient_21_8`"). This directory contains the SQLPLUS executable along with all the required DLL.

> You should add the path to the SQLPLUS executable (`sqlplus.exe`) into your system PATH environment variable.

Try to connect:

```dos
SET DB_HOST=192.168.1.18
SET DB_USER=system
SET DB_PASSWORD=1234
sqlplus %DB_USER%/%DB_PASSWORD%@//%DB_HOST%/XEPDB1
```

> We assume that the Docker container is running on the host whose IP address is `192.168.1.18`.
>
> Please note that `XEPDB1` is the "global name" of the database. It is also the "service name" since no service name has been explicitly set.
>
>		SQL> select * from global_name;
>		
>		GLOBAL_NAME
>		--------------------------------------------------------------------------------
>		XEPDB1
>
> A global name refers to the full name of a database (including its domain) which uniquely identifies it from any other database. An example global name might be `FaqDB1.orafaq.com`. 
> **If you do not specify a SERVICE_NAME for a database, the service name will default to the database's global name** ([source](https://www.orafaq.com/wiki/Global_name)).
>
> Get the name of the SID for the currently connected used:
>
>		SELECT sys_context('USERENV', 'SID') FROM DUAL;
>
> Get the name of the instance for the currently connected used:
>
>		SELECT sys_context('userenv','instance_name') FROM dual;

