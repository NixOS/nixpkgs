{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "lmp";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "0xInfection";
    repo = "LogMePwn";
    rev = "v${version}";
    sha256 = "sha256-3kxMtkHkqo5Gwk864Bb8MqRtuC8HP38Xl22ktiTgr5k=";
  };

  vendorSha256 = "sha256-X7Djcp4reOXL6SX4jiSLicolENu7Uo5webSePYrPKug=";

  meta = with lib; {
    description = "Scanning and validation toolkit for the Log4J vulnerability";
    homepage = "https://github.com/0xInfection/LogMePwn";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
