{ lib, self, ... }:
let
  jobs = lib.genAttrs lib.systems.flakeExposed (
    system:
    import ./release.nix {
      nixpkgs = self;
      inherit system;
    }
  );
in
{
  inherit jobs;

  outputs = {
    legacyPackages = lib.genAttrs lib.systems.flakeExposed (
      system:
      import ../.. {
        inherit system;
        overlays = import ./impure-overlays.nix ++ [
          (final: prev: {
            lib = prev.lib.extend (import ../../lib/flake-version-info.nix self);
          })
        ];
      }
    );

    checks =
      lib.genAttrs
        (lib.filter (
          system:
          # Exclude x86_64-freebsd because "Failed to evaluate rustc-wrapper-1.85.0: «broken»: is marked as broken"
          system != "x86_64-freebsd"
        ) lib.systems.flakeExposed)
        (system: {
          inherit (jobs.${system}) tarball;
        });
  };
}
