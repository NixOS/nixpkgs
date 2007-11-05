{
	pkgs, config
}:
let
	configFile = ./xfs.conf;
  startingDependency = if (config.get [ "services" "gw6c" "enable" ]) 
	then "gw6c" else "network-interfaces";
in
rec {
	name = "xfs";
	groups = [];
	users = [];
	job = "
		description = \"X Font Server\"
		start on ${startingDependency}/started
		stop on ${startingDependency}/stop

		respawn ${pkgs.xorg.xfs}/bin/xfs -config ${configFile}
	";
}
