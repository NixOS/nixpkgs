{
  lib,
  haskell,
  haskellPackages,
  runCommand,
}:

let
  localRaw = haskellPackages.callPackage ./generated.nix { };

  # A patched variant to test that buildFromCabalSdist respects patches
  localPatched = haskell.lib.appendPatches localRaw [ ./change-greeting.patch ];
in
lib.recurseIntoAttrs rec {

  helloFromCabalSdist = haskellPackages.buildFromCabalSdist haskellPackages.hello;

  # A more complicated example with a cabal hook.
  hercules-ci-cnix-store = haskellPackages.buildFromCabalSdist haskellPackages.hercules-ci-cnix-store;

  localFromCabalSdist = haskellPackages.buildFromCabalSdist localRaw;

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
        grep ${localRaw.src} $drvPath >/dev/null
        touch $out
      '';

  localHasNoDirectReference =
    runCommand "localHasNoDirectReference"
      {
        drvPath = builtins.unsafeDiscardOutputDependency localFromCabalSdist.drvPath;
      }
      ''
        grep -v ${localRaw.src} $drvPath >/dev/null
        touch $out
      '';

  # Test that buildFromCabalSdist respects patches applied to the package.
  # The patch changes the greeting from "Hello, Haskell!" to "Hello, Patched Haskell!".
  localPatchedFromCabalSdist = haskellPackages.buildFromCabalSdist localPatched;

  patchRespected =
    runCommand "patchRespected"
      {
        nativeBuildInputs = [ localPatchedFromCabalSdist ];
      }
      ''
        ${lib.getExe localPatchedFromCabalSdist} | grep "Patched" >/dev/null
        touch $out
      '';

  # Test that buildFromSdist (non-cabal-install variant) also respects patches.
  localPatchedFromSdist = haskell.lib.buildFromSdist localPatched;

  patchRespectedSdist =
    runCommand "patchRespectedSdist"
      {
        nativeBuildInputs = [ localPatchedFromSdist ];
      }
      ''
        ${lib.getExe localPatchedFromSdist} | grep "Patched" >/dev/null
        touch $out
      '';
}
