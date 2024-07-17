{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "license-generator";
  version = "1.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-OIut6eE8cm7eBeHwuCUqSMDH48ZiJpF4vFaQ6wVLnfg=";
  };

  cargoHash = "sha256-tv3Qx4JP2Lbl+k686mX7acabh7nyP1E9w7cQUnjh+pE=";

  meta = with lib; {
    description = "Command-line tool for generating license files";
    homepage = "https://github.com/azu/license-generator";
    license = licenses.mit;
    maintainers = with maintainers; [ loicreynier ];
    mainProgram = "license-generator";
  };
}
