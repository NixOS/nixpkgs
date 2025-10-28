# legacy texlive.combine wrapper
{
  lib,
  toTLPkgList,
  toTLPkgSets,
  buildTeXEnv,
}:
args@{
  pkgFilter ? (
    pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "core" || pkg.hasManpages or false
  ),
  extraName ? "combined",
  extraVersion ? "",
  ...
}:
let
  pkgSet = removeAttrs args [
    "pkgFilter"
    "extraName"
    "extraVersion"
  ];

  # combine a set of TL packages into a single TL meta-package
  combinePkgs =
    pkgList:
    lib.catAttrs "pkg" (
      let
        # a TeX package used to be an attribute set { pkgs = [ ... ]; ... } where pkgs is a list of derivations
        # the derivations make up the TeX package and optionally (for backward compatibility) its dependencies
        tlPkgToSets =
          drv:
          map (
            {
              tlType,
              version ? "",
              outputName ? "",
              ...
            }@pkg:
            {
              # outputName required to distinguish among bin.core-big outputs
              key = "${pkg.pname or pkg.name}.${tlType}-${version}-${outputName}";
              inherit pkg;
            }
          ) (drv.pkgs or (toTLPkgList drv));
        pkgListToSets = lib.concatMap tlPkgToSets;
      in
      builtins.genericClosure {
        startSet = pkgListToSets pkgList;
        operator = { pkg, ... }: pkgListToSets (pkg.tlDeps or [ ]);
      }
    );
  combined = combinePkgs (lib.attrValues pkgSet);

  # convert to specified outputs
  tlTypeToOut = {
    run = "tex";
    doc = "texdoc";
    source = "texsource";
    bin = "out";
    tlpkg = "tlpkg";
  };
  toSpecified =
    { tlType, ... }@drv:
    drv
    // {
      outputSpecified = true;
      tlOutputName = tlTypeToOut.${tlType};
    };
  all = lib.filter pkgFilter combined ++ lib.filter (pkg: pkg.tlType == "tlpkg") combined;
  converted = map toSpecified all;
in
buildTeXEnv {
  __extraName = extraName;
  __extraVersion = extraVersion;
  requiredTeXPackages = _: converted;
  __combine = true;
  __fromCombineWrapper = true;
}
