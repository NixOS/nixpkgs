{
        pkgs, config
}:
if ! config.fonts.enableFontDir then abort "Please enable fontDir (fonts.enableFontDir) to use xfs." else
let
        configFile = ./xfs.conf;
  startingDependency = if config.services.gw6c.enable && config.services.gw6c.autorun then "gw6c" else "network-interfaces";
in
rec {
        name = "xfs";
        groups = [];
        users = [];
        job = "
                description \"X Font Server\"
                start on ${startingDependency}/started
                stop on shutdown

                respawn ${pkgs.xorg.xfs}/bin/xfs -config ${configFile}
        ";
}
