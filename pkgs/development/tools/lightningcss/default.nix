{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.21.6";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "refs/tags/v${version}";
    sha256 = "esLPAKdqYdpB3/ffsV/NAmfjGU9G8y13f/59bWD0yR0=";
  };

  cargoHash = "sha256-8k6BhhBQ8X08vW0a8x8v1YNwiXFrzvWxcL47XdaqWJs=";

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
