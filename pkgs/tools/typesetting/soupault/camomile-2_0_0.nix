{ lib
, ocamlPackages
, fetchFromGitHub
}:

# There was little interest in upstreaming this package as a whole, at
# least for now. See Microsoft GitHub Issue:
# https://github.com/NixOS/nixpkgs/issues/224318

ocamlPackages.buildDunePackage rec {
  pname = "camomile";
  version = "2.0.0";

  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "Camomile";
    rev = "v${version}";
    sha256 = "sha256-HklX+VPD0Ta3Knv++dBT2rhsDSlDRH90k4Cj1YtWIa8=";
  };

  buildInputs = with ocamlPackages; [
    camlp-streams
    dune-site
  ];

  meta = {
    license = lib.licenses.lgpl21;
  };
}
