{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, Security
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "hiksink";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "CornerBit";
    repo = pname;
    rev = version;
    sha256 = "sha256-k/cBCc7DywyBbAzCRCHdrOVmo+QVCsSgDn8hcyTIUI8=";
  };

  cargoSha256 = "sha256-vqzXpSPBwY7m/Fdob0mHH0OXnzyQwFk7x2kk9Tgez3M=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Tool to convert Hikvision camera events to MQTT";
    homepage = "https://github.com/CornerBit/HikSink";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "hik_sink";
  };
}
