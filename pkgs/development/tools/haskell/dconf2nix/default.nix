{
  haskell,
  haskellPackages,
  runCommand,
}:

let
  dconf2nix = haskell.lib.compose.justStaticExecutables haskellPackages.dconf2nix;
in

dconf2nix.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or { }) // {
    updateScript = ./update.sh;

    # These tests can be run with the following command.
    #
    # $ nix-build -A dconf2nix.passthru.tests
    tests =
      runCommand "dconf2nix-tests"
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
