{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
, gcc
, libcxx
}:

rustPlatform.buildRustPackage rec {
  pname = "fh";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "DeterminateSystems";
    repo = "fh";
    rev = "v${version}";
    hash = "sha256-lTm4C06FtlaIJyhqZ4POubiR4qc0fPHawLS4cpneACg=";
  };

  cargoHash = "sha256-CvuQeS+g9bdpYzop63BL0UKQsdOELGt1tR2Xz4FLxpE=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    gcc.cc.lib
  ];

  env = lib.optionalAttrs stdenv.isDarwin {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev libcxx}/include/c++/v1";
  };

  # Cargo.lock is outdated
  postConfigure = ''
    cargo metadata --offline
  '';

  meta = with lib; {
    description = "The official FlakeHub CLI";
    homepage = "https://github.com/DeterminateSystems/fh";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "fh";
  };
}
