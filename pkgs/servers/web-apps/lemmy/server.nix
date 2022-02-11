{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, openssl
, postgresql
, libiconv
, Security
, protobuf
}:
let
  pinData = lib.importJSON ./pin.json;
  version = pinData.version;
in
rustPlatform.buildRustPackage rec {
  inherit version;
  pname = "lemmy-server";

  src = fetchFromGitHub {
    owner = "LemmyNet";
    repo = "lemmy";
    rev = version;
    sha256 = pinData.serverSha256;
  };

  cargoSha256 = pinData.serverCargoSha256;

  buildInputs = [ postgresql ]
    ++ lib.optionals stdenv.isDarwin [ libiconv Security ];

  # Using OPENSSL_NO_VENDOR is not an option on darwin
  # As of version 0.10.35 rust-openssl looks for openssl on darwin
  # with a hardcoded path to /usr/lib/libssl.x.x.x.dylib
  # https://github.com/sfackler/rust-openssl/blob/master/openssl-sys/build/find_normal.rs#L115
  OPENSSL_LIB_DIR = "${openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${openssl.dev}/include";

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  nativeBuildInputs = [ protobuf ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "🐀 Building a federated alternative to reddit in rust";
    homepage = "https://join-lemmy.org/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ happysalada ];
  };
}
