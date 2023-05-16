{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
<<<<<<< HEAD
=======
, llvmPackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, rocksdb
, testers
, surrealdb
, SystemConfiguration
, protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "1.0.0-beta.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-rBqg8tMcdc9VavYQDiKQwNp2IxYvpDNB/Qb74uiMmO4=";
  };

  cargoHash = "sha256-qbKc9/n4bOvdP2iXg6IF3jAwxx6Wj17Uxlj3F/gx+1g=";

  # error: linker `aarch64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml
  '';
=======
    sha256 = "sha256-GgRsRGYnaE2TssoXdubEuMEbLjM4woE3vxTxSlufquU=";
  };

  cargoSha256 = "sha256-eLJ+sxsK45pkgNUYrNuUOAqutwIjvEhGGjsvwGzfVKI=";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  ROCKSDB_INCLUDE_DIR = "${rocksdb}/include";
  ROCKSDB_LIB_DIR = "${rocksdb}/lib";

  nativeBuildInputs = [
    pkg-config
<<<<<<< HEAD
    rustPlatform.bindgenHook
=======
    # needed on top of LIBCLANG_PATH to compile rquickjs
    llvmPackages.clang
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
