{
  pkgspath ? ../../..,
  test-pkgspath ? pkgspath,
  localSystem ? {
    system = builtins.currentSystem;
  },
  crossSystem ? null,
  bootstrapFiles ? null,
}:

let
  cross = if crossSystem != null then { inherit crossSystem; } else { };

  custom-bootstrap =
    if bootstrapFiles != null then
      {
        stdenvStages =
          args:
          let
            args' = args // {
              bootstrapFiles = bootstrapFiles;
            };
          in
          (import "${pkgspath}/pkgs/stdenv/darwin" args');
      }
    else
      { };

  pkgs = import pkgspath ({ inherit localSystem; } // cross // custom-bootstrap);

  build = pkgs.callPackage ./stdenv-bootstrap-tools.nix { };

  bootstrapTools = pkgs.callPackage ./bootstrap-tools.nix {
    inherit (build.bootstrapFiles) bootstrapTools unpack;
  };

  test = pkgs.callPackage ./test-bootstrap-tools.nix { inherit bootstrapTools; };

  # The ultimate test: bootstrap a whole stdenv from the tools specified above and get a package set out of it
  # eg: nix-build -A freshBootstrapTools.test-pkgs.stdenv
  test-pkgs = import test-pkgspath {
    # if the bootstrap tools are for another platform, we should be testing
    # that platform.
    localSystem = if crossSystem != null then crossSystem else localSystem;

    stdenvStages =
      args:
      let
        args' = args // {
          inherit (build) bootstrapFiles;
        };
      in
      (import (test-pkgspath + "/pkgs/stdenv/darwin") args');
  };
in
{
  inherit
    build
    bootstrapTools
    test
    test-pkgs
    ;

  inherit (build) bootstrapFiles;
}
