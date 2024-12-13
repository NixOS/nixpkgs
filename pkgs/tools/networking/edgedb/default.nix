{
  stdenv,
  lib,
  patchelf,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  pkg-config,
  curl,
  openssl,
  xz,
  substituteAll,
  # for passthru.tests:
  edgedb,
  testers,
}:
rustPlatform.buildRustPackage rec {
  pname = "edgedb";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "edgedb";
    repo = "edgedb-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-P55LwByDVO3pEzg4OZldXiyli8s5oHvV8MXCDwkF2+8=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-oRtgORzp0tabPcyArPgG8LGfYlSPhpaeRPT9QWF5BGs=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs =
    [
      curl
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      xz
    ];

  checkFeatures = [ ];

  patches = [
    (substituteAll {
      src = ./0001-dynamically-patchelf-binaries.patch;
      inherit patchelf;
      dynamicLinker = stdenv.cc.bintools.dynamicLinker;
    })
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = edgedb;
    command = "edgedb --version";
  };

  meta = {
    description = "EdgeDB cli";
    homepage = "https://www.edgedb.com/docs/cli/index";
    license = with lib.licenses; [
      asl20
      # or
      mit
    ];
    maintainers = with lib.maintainers; [
      ahirner
      kirillrdy
    ];
    mainProgram = "edgedb";
  };
}
