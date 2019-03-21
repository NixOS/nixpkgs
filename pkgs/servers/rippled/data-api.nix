{ lib, fetchgit, nodePackages }:

with lib;

let
  np = nodePackages.override { generated = ./package.nix; self = np; };
in nodePackages.buildNodePackage rec {
  name = "ripple-data-api-${version}";
  version = lib.strings.substring 0 7 rev;
  rev = "c56b860105f36c1c44ae011189d495272648c589";

  src = fetchgit {
    url = https://github.com/ripple/ripple-data-api.git;
    inherit rev;
    sha256 = "1iygp26ilradxj268g1l2y93cgrpchqwn71qdag67lv273dbq48m";
  };

  deps = (filter (v: nixType v == "derivation") (attrValues np));

  meta = {
    description = "Historical ripple data";
    homepage = https://github.com/ripple/ripple-data-api;
    maintainers = with maintainers; [ offline ];
  };
}
