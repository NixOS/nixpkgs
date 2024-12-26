{
  lib,
  haskell,
  haskellPackages,
  runCommand,
}:

let
  src = lib.fileset.toSource {
    root = ./local;
    fileset = lib.fileset.unions [
      ./local/app
      ./local/CHANGELOG.md
      ./local/local.cabal
    ];
  };
  # This prevents the source from depending on the formatting of the ./local/generated.nix file
  localRaw = haskell.lib.compose.overrideSrc {
    inherit src;
  } (haskellPackages.callPackage ./local/generated.nix { });
in
lib.recurseIntoAttrs rec {

  helloFromCabalSdist = haskellPackages.buildFromCabalSdist haskellPackages.hello;

  # A more complicated example with a cabal hook.
  hercules-ci-cnix-store = haskellPackages.buildFromCabalSdist haskellPackages.hercules-ci-cnix-store;

  localFromCabalSdist = haskellPackages.buildFromCabalSdist localRaw;

  # NOTE: ./local refers to the "./." path in `./local/generated.nix`.
  # This test makes sure that localHasNoDirectReference can actually fail if
  # it doesn't do anything. If this test fails, either the test setup was broken,
  # or Haskell packaging has changed the way `src` is treated in such a way that
  # either the test or the design of `buildFromCabalSdist` needs to be reconsidered.
  assumptionLocalHasDirectReference =
    runCommand "localHasDirectReference"
      {
        drvPath = builtins.unsafeDiscardOutputDependency localRaw.drvPath;
      }
      ''
        grep ${src} $drvPath >/dev/null
        touch $out
      '';

  localHasNoDirectReference =
    runCommand "localHasNoDirectReference"
      {
        drvPath = builtins.unsafeDiscardOutputDependency localFromCabalSdist.drvPath;
      }
      ''
        grep -v ${src} $drvPath >/dev/null
        touch $out
      '';
}
