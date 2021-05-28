{ lib
, newScope
, overrides ? (self: super: {})
}:

let
  packages = self:
    let
      callPackage = newScope self;

      prefer = version: path:
        let
          packages = callPackage path { };

        in
          packages."${version}".overrideAttrs (_: {
              passthru = packages;
            }
          );

      buildDhallPackage =
        callPackage ../development/interpreters/dhall/build-dhall-package.nix { };

      buildDhallGitHubPackage =
        callPackage ../development/interpreters/dhall/build-dhall-github-package.nix { };

      buildDhallDirectoryPackage =
        callPackage ../development/interpreters/dhall/build-dhall-directory-package.nix { };

    in
      { inherit
          buildDhallPackage
          buildDhallGitHubPackage
          buildDhallDirectoryPackage
        ;

        dhall-kubernetes =
          prefer "3.0.0" ../development/dhall-modules/dhall-kubernetes.nix;

        dhall-packages =
          prefer "0.11.1" ../development/dhall-modules/dhall-packages.nix;

        Prelude =
          prefer "13.0.0" ../development/dhall-modules/Prelude.nix;
      };

in
  lib.fix' (lib.extends overrides packages)
