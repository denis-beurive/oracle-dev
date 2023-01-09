


# Create the AQ administrator

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




