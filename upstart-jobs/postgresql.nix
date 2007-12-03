args: with args;

let

cfg = config.services.postgresql;
postgresqlService = import ../services/postgresql {
	inherit (pkgs) stdenv postgresql su;
	inherit (cfg) port logDir dataDir
		subServices allowedHosts
		authMethod;
	serverUser = "postgres";
};

in
{
	name = "postgresql";
	users = [ {
		name = "postgres";
		description = "PostgreSQL server user";
	} ];
	groups = [{name = "postgres";}];
	job = "
description \"PostgreSQL server\"

start on ${startDependency}/started
stop on ${startDependency}/stop

respawn ${postgresqlService}/bin/control start
	";
}
