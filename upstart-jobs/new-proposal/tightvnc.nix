{ path, thisConfig, config, lib, pkgs, upstartHelpers } : with upstartHelpers; rec {
  options = {
    description = "tightvnc vnc server (share virtual desktop over network";

    geometry = mkOption {
      default = "-geometry 800x600";
      example = "800x600";
      description = ''
        size of virtual screen
      '';
      apply = x :  "-geometry '${x}'";
    };
    depth = mkOption {
      default = "-depth 24";
      description = ''
        use screen-name instead the hostname to identify
        this screen in the configuration.
        value must be something between 8 and 32
        '';
      apply = x: "-depth '${x}'";
      check = x: (__lessThan x 33) && (7 __lessThan x); # not yet used
    };
    display = mkOption {
      default = ":8";
      example = 8;
      description = "display to use";
      apply = x: ":${builtins.toString x}";
    };
    authFile = mkOption {
      default = "-auth /etc/tightvnc-pwd";
      description = ''
        The file containing authentication passwords.
        Can be created using vncpasswd
      '';
      apply = x: "-auth '${x}'";
      check = __pathExists;
    };
    httpPort = mkOption {
      default = "-httpport 5900";
      example = 5901;
      description = "http port to listen to (Java applet remote interface)";
      apply = x: "-httpport '${builtins.toString x}'";
    };
    desktopName = mkOption {
      description = ''
        Set VNC desktop name ("x11" by default)
      '';
      apply = x: "-desktop '${x}'";
    };
    viewOnly = mkOption {
      default = "";
      description = ''
        Don't accept keboard and pointer events from clients. All clients will be able to see
        the desktop but won't be able to control it.
      '';
      apply = x: "-viewonly '${x}'";
    };
    interface = mkOption {
      default = "";
      description = ''
        Listen for client connections only on the network interface with given ipaddr
      '';
      apply = x: "-interface '${x}'";
    };
    extras = mkOption {
      default = "";
      description = ''
        additional params, see man Xvnc
      '';
    };
  };

  jobs = if (lib.getAttr ["services" "xfs" "enable"] false config) != true
    then abort "you need to enable xfs services = { xfs = { enable = true; }; } within your nixos/configuration.nix file"
    else
    [ ( rec {
      name = "tightvnc";

  job = "
description \"${name}\"

start on network-interfaces/started and xserver/started
stop on network-interfaces/stop or xserver/stop

exec ${pkgs.tightvnc}/bin/Xvnc -fp unix/:7100 ${lib.concatStringsSep " " (lib.mapIf (x : x != "description") configV (__attrNames options ) ) }
  ";
} ) ];
}
# 
