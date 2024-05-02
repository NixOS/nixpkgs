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

  badBranchError =
    branch:
    throw ''
      Unknown FreeBSD branch ${branch}!
      FreeBSD branches normally look like one of:
      * `release/<major>.<minor>.0` for tagged releases without security updates
      * `releng/<major>.<minor>` for release update branches with security updates
      * `stable/<major>` for stable versions working towards the next minor release
      * `main` for the latest development version

      Set one with the NIXPKGS_FREEBSD_BRANCH environment variable or by setting `nixpkgs.config.freebsdBranch`.
    '';

  attributes =
    let
      supported13 = "release/13.1.0";
      supported14 = "release/14.0.0";
      branch =
        let
          fallbackBranch = supported13;
          envBranch = builtins.getEnv "NIXPKGS_FREEBSD_BRANCH";
          selectedBranch =
            if config.freebsdBranch != null then
              config.freebsdBranch
            else if envBranch != "" then
              envBranch
            else
              null;
          chosenBranch = if selectedBranch != null then selectedBranch else fallbackBranch;
        in
        chosenBranch;
    in
    {
      freebsd = versions.${branch} or (badBranchError branch);
      freebsd13 = versions.${supported13} or (badBranchError supported13);
      freebsd14 = versions.${supported14} or (badBranchError supported14);
    };

  # `./package-set.nix` should never know the name of the package set we
  # are constructing; just this function is allowed to know that. This
  # is why we:
  #
  #  - do the splicing for cross compilation here
  #
  #  - construct the *anonymized* `buildFreebsd` attribute to be passed
  #    to `./package-set.nix`.
  callFreeBSDWithAttrs =
    extraArgs: attribute: sourceData:
    let
      otherSplices = generateSplicesForMkScope [ attribute ];
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

  exportedAttrSetsNative = lib.mapAttrs (callFreeBSDWithAttrs { }) attributes;

  exportedAttrSetsCross = lib.mapAttrs' (
    name: sourceData:
    lib.nameValuePair (name + "Cross") (
      callFreeBSDWithAttrs { stdenv = crossLibcStdenv; } name sourceData
    )
  ) attributes;
in

exportedAttrSetsNative // exportedAttrSetsCross
