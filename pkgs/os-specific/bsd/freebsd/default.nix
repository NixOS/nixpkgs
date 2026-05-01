{
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  callPackage,
  attributePathToSplice ? [ "freebsd" ],
  branch ? "release/14.2.0",
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

      Branches can be selected by overriding the `branch` attribute on the freebsd package set.
    '';

  # we do not include the branch in the splice here because the branch
  # parameter to this file will only ever take on one value - more values
  # are provided through overrides.
  otherSplices = generateSplicesForMkScope attributePathToSplice;
in
# `./package-set.nix` should never know the name of the package set we
# are constructing; just this function is allowed to know that. This
# is why we:
#
#  - do the splicing for cross compilation here
#
#  - construct the *anonymized* `buildFreebsd` attribute to be passed
#    to `./package-set.nix`.
makeScopeWithSplicing' {
  inherit otherSplices;
  f =
    self:
    {
      inherit branch;
    }
    // callPackage ./package-set.nix {
      sourceData = versions.${self.branch} or (throw (badBranchError self.branch));
      versionData = self.sourceData.version;
      buildFreebsd = otherSplices.selfBuildHost;
      patchesRoot = ./patches + "/${self.versionData.revision}";
    } self;
}
