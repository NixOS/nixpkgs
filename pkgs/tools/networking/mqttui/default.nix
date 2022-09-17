{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mqttui";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "EdJoPaTo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GoSIck/P6s6flmfz2JbHZLgQJXXpLaxShOhmghIIMNc=";
  };

  cargoSha256 = "sha256-oxbHaSS9+J3KPvKDdi+tpl2BI/YdppyxqSyCSfSxjMY=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "Terminal client for MQTT";
    homepage = "https://github.com/EdJoPaTo/mqttui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
