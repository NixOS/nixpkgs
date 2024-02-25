{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.23.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "refs/tags/v${version}";
    hash = "sha256-vMxf5WQtoj7FycU1zHn5t/bJtwh6t4wqyKfoetzojzU=";
  };

  cargoHash = "sha256-g7/1s3FvuwsJvypeHOqJA/lVBkQcLATWtlygI8IW+QA=";

  buildFeatures = [
    "cli"
  ];

  cargoBuildFlags = [
    "--lib"
    "--bin=lightningcss"
  ];

  cargoTestFlags = [
    "--lib"
  ];

  meta = with lib; {
    description = "Extremely fast CSS parser, transformer, and minifier written in Rust";
    homepage = "https://lightningcss.dev/";
    changelog = "https://github.com/parcel-bundler/lightningcss/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ toastal ];
    mainProgram = "lightningcss";
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
