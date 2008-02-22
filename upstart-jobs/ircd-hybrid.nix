{config, pkgs}:
let
	cfg = config.services.ircdHybrid;
	ircdService = import ../services/ircd-hybrid {
		stdenv = pkgs.stdenv;
		inherit (pkgs) ircdHybrid coreutils 
			su iproute gnugrep procps;
		serverName = cfg.serverName;
		sid = cfg.sid;
		description = cfg.description;
		rsaKey = cfg.rsaKey;
		certificate = cfg.certificate;
		adminEmail = cfg.adminEmail;
		extraIPs = cfg.extraIPs;
		extraPort = cfg.extraPort;
		gw6cEnabled = (config.services.gw6c.enable) &&
			(config.services.gw6c.autorun);
	};

  startingDependency = if config.services.gw6c.enable then "gw6c" else "network-interfaces";

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
