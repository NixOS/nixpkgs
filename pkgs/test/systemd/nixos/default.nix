{
  pkgs,
  lib,
  stdenv,
  ...
}:

lib.runTests {
  # Merging two non-list definitions must still result in an error
  # about a conflicting definition.
  test-unitOption-merging-non-lists-conflict =
    let
      nixos = pkgs.nixos {
        system.stateVersion = lib.trivial.release;
        systemd.services.systemd-test-nixos = {
          serviceConfig = lib.mkMerge [
            { StateDirectory = "foo"; }
            { StateDirectory = "bar"; }
          ];
        };
      };
    in
    {
      expr =
        (builtins.tryEval (nixos.config.systemd.services.systemd-test-nixos.serviceConfig.StateDirectory))
        .success;
      expected = false;
    };

  # Merging must lift non-list definitions to a list
  # if at least one of them is a list.
  test-unitOption-merging-list-non-list-append =
    let
      nixos = pkgs.nixos {
        system.stateVersion = lib.trivial.release;
        systemd.services.systemd-test-nixos = {
          serviceConfig = lib.mkMerge [
            { StateDirectory = "foo"; }
            { StateDirectory = [ "bar" ]; }
          ];
        };
      };
    in
    {
      expr = nixos.config.systemd.services.systemd-test-nixos.serviceConfig.StateDirectory;
      expected = [
        "foo"
        "bar"
      ];
    };
}
