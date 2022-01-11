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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "CornerBit";
    repo = pname;
    rev = version;
    sha256 = "1m8hd7qbasxyq09ycnqma2y4b9s2k54h9i2rkzsa9sksc868wxh8";
  };

  cargoSha256 = "15r6rwhyy0s5i0v9nzx3hfl5cvlb0hxnllcwfnw0bbn9km25l9r3";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optional stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "Tool to convert Hikvision camera events to MQTT";
    homepage = "https://github.com/CornerBit/HikSink";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
