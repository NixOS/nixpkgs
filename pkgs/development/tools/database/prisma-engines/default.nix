{ fetchFromGitHub
, lib
, Security
, openssl
, pkg-config
, protobuf
, rustPlatform
, stdenv
}:

# Updating this package will force an update for nodePackages.prisma. The
# version of prisma-engines and nodePackages.prisma must be the same for them to
# function correctly.
rustPlatform.buildRustPackage rec {
  pname = "prisma-engines";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma-engines";
    rev = version;
    sha256 = "sha256-lIHE63XIPutvTS2cid0+tuo+JMSKMGuSUcnFv1mCRrM=";
  };

  # Use system openssl.
  OPENSSL_NO_VENDOR = 1;

  cargoSha256 = "sha256-SkI+GLHknC+CGhGo7KiZahBxMp/JCIukTe2C0mMTdjY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    protobuf
  ] ++ lib.optionals stdenv.isDarwin [ Security ];

  preBuild = ''
    export OPENSSL_DIR=${lib.getDev openssl}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib

    export PROTOC=${protobuf}/bin/protoc
    export PROTOC_INCLUDE="${protobuf}/include";

    export SQLITE_MAX_VARIABLE_NUMBER=250000
    export SQLITE_MAX_EXPR_DEPTH=10000
  '';

  cargoBuildFlags = "-p query-engine -p query-engine-node-api -p migration-engine-cli -p introspection-core -p prisma-fmt";

  postInstall = ''
    mv $out/lib/libquery_engine${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libquery_engine.node
  '';

  # Tests are long to compile
  doCheck = false;

  meta = with lib; {
    description = "A collection of engines that power the core stack for Prisma";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pamplemousse pimeys superherointj ];
  };
}
