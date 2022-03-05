{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Uts9hKhnFNYdQhxeUoTOehCcfgqQwStSoGWixgY3dPU=";
  };

  cargoSha256 = "sha256-YxXniyuQEM+vrCbflqCLlnXpH3ClAd9O496SFVKRvBs=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
