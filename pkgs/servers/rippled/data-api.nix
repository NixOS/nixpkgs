{ lib, fetchFromGitHub, nodePackages }:

with lib;

let
  np = nodePackages.override { generated = ./package.nix; self = np; };
in nodePackages.buildNodePackage rec {
  pname = "ripple-data-api";
  version = "unstable-2015-03-26";

  src = fetchFromGitHub {
    owner = "ripple";
    repo = "ripple-data-api";
    rev = "c56b860105f36c1c44ae011189d495272648c589";
    sha256 = "sha256-QEBdYdW55sAz6jshIAr2dSfXuqE/vqA2/kBeoxf75a8=";
  };

  deps = (filter (v: nixType v == "derivation") (attrValues np));

  meta = {
    description = "Historical ripple data";
    homepage = "https://github.com/ripple/ripple-data-api";
    maintainers = with maintainers; [ offline ];
  };
}
