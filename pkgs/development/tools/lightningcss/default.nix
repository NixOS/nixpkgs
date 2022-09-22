{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "v${version}";
    sha256 = "sha256-ze8+/34KeSQi2ftcpJYjF/EEFKYxkYijkpf+5eTo0Nk=";
  };

  cargoSha256 = "sha256-4lJi1jCJoJdOz+NrlXS4O59rSq9Mz4e4O3zFNE/v+dE=";

  buildFeatures = [ "cli" ];

  cargoBuildFlags = [ "--lib" "--bin=lightningcss" ];

  cargoTestFlags = [ "--lib" ];

  meta = with lib; {
    description = "Extremely fast CSS parser, transformer, and minifier written in Rust";
    homepage = "https://lightningcss.dev/";
    license = licenses.mpl20;
    maintainers = with maintainers; [ toastal ];
  };
}
