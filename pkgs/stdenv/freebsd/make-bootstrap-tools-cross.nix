{system ? builtins.currentSystem}:

let
  inherit (releaseLib) lib;
  releaseLib = import ../../top-level/release-lib.nix {
    # We're not using any functions from release-lib.nix that look at
    # supportedSystems.
    supportedSystems = [];
  };

  make = crossSystem: import ./make-bootstrap-tools.nix {
    pkgs = releaseLib.pkgsForCross crossSystem system;
  };
in lib.mapAttrs (n: make) (with lib.systems.examples; {
  # NOTE: Only add platforms for which there are files in `./bootstrap-files`
  # or for which you plan to request the tarball upload soon. See the
  #   maintainers/scripts/bootstrap-files/README.md
  # on how to request an upload.
  # Sort following the sorting in `./default.nix` `bootstrapFiles` argument.

  x86_64-unknown-freebsd = x86_64-freebsd;
})
