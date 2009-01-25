{pkgs, config, ...}:

let
  inherit (builtins) head tail;
  inherit (pkgs.lib) mkOption mkIf filter optionalString any;
  cfg = config.services.xserver.desktopManager;

  needBGCond = d: ! (d ? bgSupport && d.bgSupport);
in

{
  require = [
    (import ./kde.nix)
    (import ./gnome.nix)
    (import ./xterm.nix)
    (import ./none.nix)
  ];

  services = {
    xserver = {
      displayManager = {
        session = cfg.session.list;
      };

      desktopManager = {
        session = mkOption {
          default = [];
          example = [{
            name = "kde";
            bgSupport = true;
            start = "...";
          }];
          description = "
            Internal option used to add some common line to desktop manager
            scripts before forwarding the value to the
            <varname>displayManager</varname>.
          ";
          apply = list: {
            list = map (d: d // {
              manage = "desktop";
              start = d.start
              + optionalString (needBGCond d) ''
                if test -e $HOME/.background-image; then
                  ${pkgs.feh}/bin/feh --bg-scale $HOME/.background-image
                fi
              '';
            }) list;
            needBGPackages = [] != filter needBGCond list;
          };
        };



        default = mkOption {
          default = "xterm";
          example = "none";
          description = "
            Default desktop manager loaded if none have been chosen.
          ";
          merge = name: list:
            let defaultDM = head list; in
            if tail list != [] then
              throw "Only one default desktop manager is allowed."
            else if any (w: w.name == defaultDM) cfg.session.list then
              defaultDM
            else
              throw "Default desktop manager not found.";
        };
      };
    };
  };

  environment = mkIf cfg.session.needBGPackages {
    extraPackages = [ pkgs.feh ];
  };
}
