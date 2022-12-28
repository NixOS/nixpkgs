{ lib
, rustPlatform
, fetchCrate
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "xq";
  version = "0.2.40";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-sOCdNQ+prQRdj3Oeaa4HLhufbwtClUzzhnMDwSU4SJE=";
  };

  cargoSha256 = "sha256-b41D/sg+qD/SbwQvEqv3sFWuW15VQ4gEiL51I7/hOmI=";

  meta = with lib; {
    description = "Pure rust implementation of jq";
    homepage = "https://github.com/MiSawa/xq";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
