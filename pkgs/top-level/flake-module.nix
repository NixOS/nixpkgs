{
  config,
  lib,
  mkPerSystemOption,
  self,
  ...
}:
{
  imports = [
    (mkPerSystemOption {
      name = "legacyPackages";
      type = lib.types.unspecified;
    })
    (mkPerSystemOption {
      name = "jobs";
      type = lib.types.lazyAttrsOf lib.types.unspecified;
    })
  ];

  /**
    A nested structure of [packages](https://nix.dev/manual/nix/latest/glossary#package-attribute-set) and other values.

    The "legacy" in `legacyPackages` doesn't imply that the packages exposed
    through this attribute are "legacy" packages. Instead, `legacyPackages`
    is used here as a substitute attribute name for `packages`. The problem
    with `packages` is that it makes operations like `nix flake show
    nixpkgs` unusably slow due to the sheer number of packages the Nix CLI
    needs to evaluate. But when the Nix CLI sees a `legacyPackages`
    attribute it displays `omitted` instead of evaluating all packages,
    which keeps `nix flake show` on Nixpkgs reasonably fast, though less
    information rich.

    The reason why finding the tree structure of `legacyPackages` is slow,
    is that for each attribute in the tree, it is necessary to check whether
    the attribute value is a package or a package set that needs further
    evaluation. Evaluating the attribute value tends to require a significant
    amount of computation, even considering lazy evaluation.
  */
  perSystem.module =
    psArgs@{ system, ... }:
    {
      legacyPackages = (
        import ../.. {
          inherit system;
          overlays = import ./impure-overlays.nix ++ [
            (final: prev: {
              lib = prev.lib.extend (import ../../lib/flake-version-info.nix self);
            })
          ];
        }
      );

      jobs = import ./release.nix {
        nixpkgs = self;
        inherit system;
      };

      checks =
        lib.mkIf
          # Exclude x86_64-freebsd because "Failed to evaluate rustc-wrapper-1.85.0: «broken»: is marked as broken"
          (system != "x86_64-freebsd")
          { tarball = psArgs.config.jobs.tarball; };
    };

  outputs = { inherit (config.perSystem.applied) legacyPackages; };
}
