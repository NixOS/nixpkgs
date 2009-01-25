{pkgs, config, ...}:

let
  inherit (builtins) head tail;
  inherit (pkgs.lib) mkOption any;
  cfg = config.services.xserver.windowManager;
in

{
  require = [
    (import ./compiz.nix)
    (import ./kwm.nix)
    (import ./metacity.nix)
    (import ./none.nix)
    (import ./twm.nix)
    (import ./wmii.nix)
    (import ./xmonad.nix)
  ];

  services = {
    xserver = {
      displayManager = {
        session = cfg.session;
      };

      windowManager = {
        session = mkOption {
          default = [];
          example = [{
            name = "wmii";
            start = "...";
          }];
          description = "
            Internal option used to add some common line to window manager
            scripts before forwarding the value to the
            <varname>displayManager</varname>.
          ";
          apply = map (d: d // {
            manage = "window";
          });
        };

        default = mkOption {
          default = "none";
          example = "wmii";
          description = "
            Default window manager loaded if none have been chosen.
          ";
          merge = name: list:
            let defaultWM = head list; in
            if tail list != [] then
              throw "Only one default window manager is allowed."
            else if any (w: w.name == defaultWM) cfg.session then
              defaultWM
            else
              throw "Default window manager not found.";
        };
      };
    };
  };
}
