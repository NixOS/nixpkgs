let
  pkgs = import ./. { };
  evalConfig = import ./nixos/lib/eval-config.nix;
in
{
  test = evalConfig {
    inherit pkgs;
    modules = [
      {
        imports = [ ./nixos/tests/common/user-account.nix ];
        services.displayManager.ly = {
          enable = true;
          settings = {
            # NOTE: ly fails weirdly with a typo here
            # https://codeberg.org/fairyglade/ly/issues/969
            # default_input = "password";
            default_input = "psasword";
          };
        };
      }

      # some modules
      {
        services.displayManager.ly.x11Support = true;
        services.xserver.enable = true;
        services.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      }
    ];
  };
}
