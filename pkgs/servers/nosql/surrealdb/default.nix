{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config, openssl, llvmPackages
, testers, surrealdb
}:

rustPlatform.buildRustPackage rec {
  pname = "surrealdb";
  version = "1.0.0-beta.7";

  src = fetchFromGitHub {
    owner = "surrealdb";
    repo = "surrealdb";
    rev = "v${version}";
    hash = "sha256-Zl2ONMmVN+gXnsvTUPH37TIBquu3F1kUsATGHszNO/s=";
  };

  cargoHash = "sha256-VQlW78NNpJqKOCpOXBmNf37heftWXCIzMpYw+yQdGv4=";

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  nativeBuildInputs = [
    pkg-config
    llvmPackages.clang # needed for librocksdb-sys
  ];

  buildInputs = [ openssl ];

  passthru.tests.version = testers.testVersion {
    package = surrealdb;
    command = "surreal version";
  };

  meta = with lib; {
    description = "A scalable, distributed, collaborative, document-graph database, for the realtime web";
    homepage = "https://surrealdb.com/";
    mainProgram = "surreal";
    license = licenses.bsl11;
    maintainers = with maintainers; [ sikmir ];
  };
}
