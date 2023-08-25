params: with params;
# texlive.combine backward compatibility
args@{
  pkgFilter ? (pkg: pkg.tlType == "run" || pkg.tlType == "bin" || pkg.pname == "core"
                    || pkg.hasManpages or false)
, extraName ? "combined"
, extraVersion ? ""
, ...
}:
let
  pkgSet = removeAttrs args [ "pkgFilter" "extraName" "extraVersion" ];
  combined = combinePkgs (lib.attrValues pkgSet);
  tlTypeToOutName = { run = "tex"; doc = "texdoc"; source = "texsource"; bin = "out"; tlpkg = "tlpkg"; };
  # in case of old style { pkgs = [ ... ]; } packages, convert them to specified outputs of the right name
  convertToSpecified = p: p // { outputSpecified = true; tlOutputName = tlTypeToOutName.${p.tlType}; };
  all = lib.filter pkgFilter combined ++ lib.filter (pkg: pkg.tlType == "tlpkg") combined;
  converted = builtins.map convertToSpecified all;
in
__buildEnv {
  inherit extraName extraVersion;
  packages = _: converted;
  __calledFromCombine = true;
}
