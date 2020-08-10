{ haskell, haskellPackages, lib, runCommand }:

let
  dconf2nix =
    haskell.lib.justStaticExecutables
      (haskell.lib.overrideCabal haskellPackages.dconf2nix (oldAttrs: {
        maintainers = (oldAttrs.maintainers or []) ++ [
          lib.maintainers.gvolpe
        ];
      }));
in

dconf2nix.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or {}) // {
    updateScript = ./update.sh;

    # These tests can be run with the following command.
    #
    # $ nix-build -A dconf2nix.passthru.tests
    tests =
      runCommand
        "dconf2nix-tests"
        {
          nativeBuildInputs = [
            dconf2nix
          ];
        }
        ''
          dconf2nix > $out
        '';
  };
})
