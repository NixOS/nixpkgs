{ lib, fetchFromGitHub, nodePackages }:

with lib;

let
  np = nodePackages.override { generated = ./package.nix; self = np; };
in nodePackages.buildNodePackage rec {
  name = "ripple-rest-${version}";
  version = "1.7.0-rc1";

  src = fetchFromGitHub {
    repo = "ripple-rest";
    owner = "ripple";
    rev = version;
    sha256 = "19ixgrz40iawd927jan0g1ac8w56wxh2vy3n3sa3dn9cmjd4k2r3";
  };

  deps = (filter (v: nixType v == "derivation") (attrValues np));

  meta = {
    description = " RESTful API for submitting payments and monitoring accounts on the Ripple Network";
    homepage = https://github.com/ripple/ripple-rest;
    maintainers = with maintainers; [ offline ];
    license = [ licenses.mit ];
    broken = true;
  };
}
