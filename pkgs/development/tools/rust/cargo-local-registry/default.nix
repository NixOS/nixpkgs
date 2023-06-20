{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, curl
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-local-registry";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "dhovart";
    repo = "cargo-local-registry";
    rev = version;
    hash = "sha256-nxLqWtZl3ZF/iodYsQCYQ/prjp80QMzJLLp31q7d2vs=";
  };

  cargoHash = "sha256-k94jzMdZDWpxSHVEZh1Qsv8OuUKuqU2YNBN1Mqj8HJA=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # tests require internet access
  doCheck = false;

  # Cargo.lock is outdated
  preConfigure = ''
    cargo metadata --offline
  '';

  meta = with lib; {
    description = "A cargo subcommand to manage local registries";
    homepage = "https://github.com/dhovart/cargo-local-registry";
    changelog = "https://github.com/dhovart/cargo-local-registry/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
