{
  lib,
  config,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  callPackage,
  crossLibcStdenv,
}:

let
  versions = builtins.fromJSON (builtins.readFile ./versions.json);

  # `./package-set.nix` should never know the name of the package set we
  # are constructing; just this function is allowed to know that. This
  # is why we:
  #
  #  - do the splicing for cross compilation here
  #
  #  - construct the *anonymized* `buildFreebsd` attribute to be passed
  #    to `./package-set.nix`.
  callFreeBSDWithAttrs =
    extraArgs: branch: sourceData:
    let
      otherSplices = generateSplicesForMkScope [
        "freebsdBranches"
        branch
      ];
    in
    makeScopeWithSplicing' {
      inherit otherSplices;
      f = callPackage ./package-set.nix (
        {
          buildFreebsd = otherSplices.selfBuildHost;
          inherit sourceData;
          versionData = sourceData.version;
          patchesRoot = ./patches/${sourceData.version.revision};
        }
        // extraArgs
      );
    };
in
{
  freebsdBranches = lib.mapAttrs (callFreeBSDWithAttrs { }) versions;

  freebsdBranchesCross = lib.mapAttrs (callFreeBSDWithAttrs { stdenv = crossLibcStdenv; }) versions;
}
