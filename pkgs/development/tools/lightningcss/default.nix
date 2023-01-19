{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "refs/tags/v${version}";
    hash = "sha256-JULVX5gyMJhnBwGQxmMObtUaenu37rIE5yDbA5fHsCY=";
  };

  cargoHash = "sha256-PQbN0qsCf4eia5sD71ltP7Y955smZPwkof+uEQATvNQ=";

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
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
