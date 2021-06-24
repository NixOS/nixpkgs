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

      buildDhallGitHubPackage =
        callPackage ../development/interpreters/dhall/build-dhall-github-package.nix { };

      buildDhallDirectoryPackage =
        callPackage ../development/interpreters/dhall/build-dhall-directory-package.nix { };

    in
      { inherit
          callPackage
          buildDhallPackage
          buildDhallGitHubPackage
          buildDhallDirectoryPackage
        ;

        lib = import ../development/dhall-modules/lib.nix { inherit lib; };

        dhall-kubernetes =
          callPackage ../development/dhall-modules/dhall-kubernetes.nix { };

        dhall-packages =
          callPackage ../development/dhall-modules/dhall-packages.nix { };

        Prelude =
          callPackage ../development/dhall-modules/Prelude.nix { };
      };

in
  lib.fix' (lib.extends overrides packages)
