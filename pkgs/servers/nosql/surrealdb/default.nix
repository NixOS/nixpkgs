{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, llvmPackages
, rocksdb
, testers
, surrealdb
, SystemConfiguration
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
  version = "1.0.0-beta.9";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    rev = "v${version}";
    sha256 = "sha256-GgRsRGYnaE2TssoXdubEuMEbLjM4woE3vxTxSlufquU=";
  };

  cargoSha256 = "sha256-eLJ+sxsK45pkgNUYrNuUOAqutwIjvEhGGjsvwGzfVKI=";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  nativeBuildInputs = [
    pkg-config
    # needed on top of LIBCLANG_PATH to compile rquickjs
    llvmPackages.clang
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
