{ haskell
, lib

# The following are only needed for the passthru.tests:
, cacert
, git
, nodejs
, purescript
, runCommand
}:

let
  spago =
    lib.pipe
      haskell.packages.ghc90.spago
      [ haskell.lib.compose.justStaticExecutables
        (haskell.lib.compose.overrideCabal (oldAttrs: {
          changelog = "https://github.com/purescript/spago/releases/tag/${oldAttrs.version}";
        }))
      ];
in

spago.overrideAttrs (oldAttrs: {
  passthru = (oldAttrs.passthru or {}) // {
    updateScript = ./update.sh;

    # These tests can be run with the following command.  The tests access the
    # network, so they cannot be run in the nix sandbox.  sudo is needed in
    # order to change the sandbox option.
    #
    # $ sudo nix-build -A spago.passthru.tests --option sandbox relaxed
    #
    tests =
      runCommand
        "spago-tests"
        {
          __noChroot = true;
          nativeBuildInputs = [
            cacert
            git
            nodejs
            purescript
            spago
          ];
        }
        ''
          # spago expects HOME to be set because it creates a cache file under
          # home.
          HOME=$(pwd)

          spago --verbose init
          spago --verbose build
          spago --verbose test

          touch $out
        '';
  };
})
