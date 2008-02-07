args: with args;

let

cfg = config.services.mysql;
mysqlService = import ../services/mysql {
	inherit (pkgs) stdenv mysql;
	inherit (cfg) port user dataDir
		logError pidFile;
};

in
{
	name = "mysql";
	job = "
description \"MySQL server\"

stop on shutdown

respawn ${mysqlService}/bin/control start
	";
}
