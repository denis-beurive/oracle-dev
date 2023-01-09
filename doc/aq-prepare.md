# Advanced Queuing

### Create the AQ administrator

Connect to the database as `system` user:

	DB_HOST="..."
	sqlplus system/1234@//${DB_HOST}/XEPDB1

Turn off substitution printings:

	SET VERIFY OFF

Create the user "`aq_admin`" (identified by the password "`password`"):

	CREATE USER aq_admin IDENTIFIED BY "password"
	       DEFAULT TABLESPACE users
	       TEMPORARY TABLESPACE temp;

Make sure that the user has been created:

	SELECT * FROM all_users WHERE USERNAME='AQ_ADMIN';

Give the previously created user unlimited quota on the table space "`users`":

	ALTER USER aq_admin QUOTA UNLIMITED ON users;

Make sure that the quota is valid:

	SELECT * FROM dba_ts_quotas WHERE username='AQ_ADMIN';

Grant roles to the user:

	GRANT aq_administrator_role TO aq_admin;
	GRANT connect TO aq_admin;
	GRANT create type TO aq_admin;

> Beginning in Oracle Database 10g Release 2, the `CONNECT` role has only the `CREATE SESSION` privilege.

Make sure that the user has the previously configured roles:

	SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE='AQ_ADMIN';

### Create the type of data used to represent a message

Connect to the database as `aq_admin` user:

	DB_HOST="..."
	sqlplus aq_admin/password@//${DB_HOST}/XEPDB1

Then create the type of data used to represent a message:

	CREATE TYPE data_message_type AS OBJECT (id NUMBER(15), payload VARCHAR2(4000));

> **WARNING**: when entering the command above, SQLPLUS may sit waiting for more input.
> In other words, SQLPLUS is waiting for more input. In this case, just enter a line containing a single "`/`".
> _A single / on a line on its own (even with spaces on either or both sides of it) is interpreted as a 
> definite end of input, even if the input isn't valid SQL._ ([source](https://stackoverflow.com/questions/5751739/how-do-i-complete-the-input-of-a-create-type-in-sqlplus-oracle))

### Create the queue table

Execute as `aq_admin` user:

	exec DBMS_AQADM.CREATE_QUEUE_TABLE (queue_table => 'aq_admin.data_qt', queue_payload_type => 'aq_admin.data_message_type');

> Please note that if you want to break the above command in multiple lines, you must end lines with a dash (`-`) ([source](https://stackoverflow.com/questions/4529665/what-is-the-correct-syntax-to-break-a-pl-sql-procedure-call-in-multiple-lines)). See next command...


### Create the queue

	exec DBMS_AQADM.CREATE_QUEUE ( -
		queue_name => 'data_queue',  -
		queue_table => 'aq_admin.data_qt', -
		queue_type => DBMS_AQADM.NORMAL_QUEUE, -
		max_retries => 0, -
		retry_delay => 0, -
		retention_time => 1209600, -
		dependency_tracking => FALSE, -
		comment => 'Test Object Type Queue', -
		auto_commit => FALSE);

* name of the queue: "`data_queue`"
* name of the table queue: "`aq_admin.data_qt`"

### Start the queue

	exec DBMS_AQADM.START_QUEUE('data_queue');

> To stop the queue: `exec DBMS_AQADM.STOP_QUEUE('data_queue');`

