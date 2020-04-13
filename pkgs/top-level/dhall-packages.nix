{ lib
, newScope
, overrides ? (self: super: {})
}:

let
  packages = self:
    let
      callPackage = newScope self;

      buildDhallPackage =
        callPackage ../development/interpreters/dhall/build-dhall-package.nix { };

    in
      { inherit buildDhallPackage;

        dhall-kubernetes =
          callPackage ../development/dhall-modules/dhall-kubernetes.nix { };

        dhall-packages =
          callPackage ../development/dhall-modules/dhall-packages.nix { };

        Prelude =
          callPackage ../development/dhall-modules/Prelude.nix { };
      };

in
  lib.fix' (lib.extends overrides packages)
