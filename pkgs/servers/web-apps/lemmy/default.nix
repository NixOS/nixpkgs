{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, postgresql
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "lemmy-server";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = "lemmy";
    rev = version;
    sha256 = "sha256-wDRBeAYjPpAd3DL99fH4Yng994hGmAmxlBqzOeXTP88=";
  };

  cargoSha256 = "sha256-7wF5mUjSeJvCNLZcR6XB31RX2RLOOEyTGpOQxg+NcWk=";

  buildInputs = [ postgresql ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  # Using OPENSSL_NO_VENDOR is not an option on darwin
  # As of version 0.10.35 rust-openssl looks for openssl on darwin
  # with a hardcoded path to /usr/lib/libssl.x.x.x.dylib
  # https://github.com/sfackler/rust-openssl/blob/master/openssl-sys/build/find_normal.rs#L115
  OPENSSL_LIB_DIR = "${openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  meta = with lib; {
    description = "Ultra relevant and instant full-text search API";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
