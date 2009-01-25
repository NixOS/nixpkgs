{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mergeOneOption any;
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
            let defaultWM = mergeOneOption name list; in
            if any (w: w.name == defaultWM) cfg.session then
              defaultWM
            else
              throw "Default window manager not found.";
        };
      };
    };
  };
}
