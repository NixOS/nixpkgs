{
  lib,
  haskellPackages,
  runCommand,
}:

let
  localRaw = haskellPackages.callPackage ./local/generated.nix { };
in
lib.recurseIntoAttrs rec {

  helloFromCabalSdist = haskellPackages.buildFromCabalSdist haskellPackages.hello;

  # A more complicated example with a cabal hook.
  hercules-ci-cnix-store = haskellPackages.buildFromCabalSdist haskellPackages.hercules-ci-cnix-store;

  localFromCabalSdist = haskellPackages.buildFromCabalSdist localRaw;

  assumptionLocalHasDirectReference =
    runCommand "localHasDirectReference"
      {
        drvPath = builtins.unsafeDiscardOutputDependency localRaw.drvPath;
      }
      ''
        grep ${./local} $drvPath >/dev/null
        touch $out
      '';

  localHasNoDirectReference =
    runCommand "localHasNoDirectReference"
      {
        drvPath = builtins.unsafeDiscardOutputDependency localFromCabalSdist.drvPath;
      }
      ''
        grep -v ${./local} $drvPath >/dev/null
        touch $out
      '';
}
