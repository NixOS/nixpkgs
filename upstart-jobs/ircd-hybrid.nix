{config, pkgs}:
let
	getCfg = option: config.get ["services" "ircdHybrid" option];
	ircdService = import ../services/ircd-hybrid {
		stdenv = pkgs.stdenvNewSetupScript;
		inherit (pkgs) ircdHybrid coreutils 
			su iproute;
		serverName = getCfg "serverName";
		sid = getCfg "sid";
		description = getCfg "description";
		rsaKey = getCfg "rsaKey";
		certificate = getCfg "certificate";
		adminEmail = getCfg "adminEmail";
		extraIPs = getCfg "extraIPs";
		extraPort = getCfg "extraPort";
		gw6cEnabled = config.get ["services" "gw6c" "enable"];
	};

  startingDependency = if (config.get [ "services" "gw6c" "enable" ]) 
	then "gw6c" else "network-interfaces";

in
{
	name = "ircd-hybrid";
	users = [ {
			name = "ircd"; 
			description = "IRCD owner.";
		} ];
	groups = [{name = "ircd";}];
	job = "
description = \"IRCD Hybrid server.\"

start on ${startingDependency}/started
stop on ${startingDependency}/stop

respawn ${ircdService}/bin/control start
";
}
