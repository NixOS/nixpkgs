{ fetchFromGitHub
, lib
, openssl
, pkg-config
, protobuf
, rustPlatform
, stdenv
}:

let
  node-api-lib = (if stdenv.isDarwin then "libquery_engine.dylib" else "libquery_engine.so");
in rustPlatform.buildRustPackage rec {
  pname = "prisma-engines";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma-engines";
    rev = version;
    sha256 = "sha256-7c9jlqMKocA3Kp39zDu2in9nRw4hZRZO1+u/eFfzWa4=";
  };

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "sha256-W3VaxG9taRv62RW6hQkfdGJo72uHK2X6JIESJEu3PXg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl protobuf ];

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${openssl.out}/lib

    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";

    export SQLITE_MAX_VARIABLE_NUMBER=250000
    export SQLITE_MAX_EXPR_DEPTH=10000
  '';

  cargoBuildFlags = "-p query-engine -p query-engine-node-api -p migration-engine-cli -p introspection-core -p prisma-fmt";

  postInstall = ''
    mv $out/lib/${node-api-lib} $out/lib/libquery_engine.node
  '';

  # Tests are long to compile
  doCheck = false;

  meta = with lib; {
    description = "A collection of engines that power the core stack for Prisma";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ pamplemousse pimeys ];
  };
}
