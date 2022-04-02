{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nLUDuLolv52WJAwBG5gSADWM2LmquJt5jZJioZWX8VA=";
  };

  cargoSha256 = "sha256-Z6V7k69fjtiG01s1Xf0UA8lhRsq3T+ImDsCHPSVIDfQ=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
