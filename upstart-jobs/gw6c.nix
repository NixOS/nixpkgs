{config, pkgs}:
let
	getCfg = option: config.get ["services" "gw6c" option];
	procps = pkgs.procps;
	gw6cService = import ../services/gw6c {
		inherit (pkgs) stdenv gw6c coreutils 
		procps upstart iputils gnused 
		gnugrep;
		username = getCfg "username";
		password = getCfg "password";
		server = getCfg "server";
		keepAlive = getCfg "keepAlive";
		everPing = getCfg "everPing";
	};
in
{
	name = "gw6c";
	users = [];
	groups = [];
	job = "
description \"Gateway6 client\"

start on network-interfaces/started
stop on network-interfaces/stop

respawn ${gw6cService}/bin/control start
";
}
