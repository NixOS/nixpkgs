{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  Security,
  openssl,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-P5h0jYSSy6i30g93Jor98vOmniJCA4eMyQkI8TLfbN8=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
