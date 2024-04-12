{ lib, stdenv, rustPlatform, python3, fetchFromGitHub, pkg-config, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "rust-synapse-compress-state";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nNQ/d4FFAvI+UY+XeqExyhngq+k+j5Pkz94ch27aoVM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "state-map-0.1.0" = "sha256-zToFCioijyT0vZ6c1uO+1ho+RODTe4OwbK2GhoKk+X4=";
    };
  };

  cargoBuildFlags = [
    "--all"
  ];

  # Needed to get openssl-sys to use pkgconfig.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ python3 pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A tool to compress some state in a Synapse instance's database";
    homepage = "https://github.com/matrix-org/rust-synapse-compress-state";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa maralorn ];
  };
}
