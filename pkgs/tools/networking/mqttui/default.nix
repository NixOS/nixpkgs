{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-taGpVLO9K5VmthWadstQcujcLHTb3fhEWDxKGd3Pj+E=";
  };

  cargoSha256 = "sha256-aAMDl8GZ+XqA4uBiDm2eHQsNFiqCrMBO66X0ruEjpJg=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
