{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, rocksdb
, testers
, surrealdb
, SystemConfiguration
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    rev = "v${version}";
    hash = "sha256-/+GAnACNzGxMDSO1BGc9dA13hZnNKDia0KBlyujEe04=";
  };

  cargoHash = "sha256-9wvgj00GAWRP9sWOgugelizB6xbPNs0h13bGGxWtA+s=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ];

  passthru.tests.version = testers.testVersion {
    package = surrealdb;
    command = "surreal version";
  };

  meta = with lib; {
    description = "A scalable, distributed, collaborative, document-graph database, for the realtime web";
    homepage = "https://surrealdb.com/";
    mainProgram = "surreal";
    license = licenses.bsl11;
    maintainers = with maintainers; [ sikmir happysalada ];
  };
}
