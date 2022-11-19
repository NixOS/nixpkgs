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
}:

rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
  version = "1.0.0-beta.8";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    rev = "v${version}";
    sha256 = "sha256-zFqHwZUpwqvuqmS18bhlpAswD5EycB3pnZwSuN5Q2G4=";
  };

  cargoSha256 = "sha256-vaAfOsbIdQXpx7v4onXY1J8ANKCccVRuWxdvX5+f2no=";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

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
