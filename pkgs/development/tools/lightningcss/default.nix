{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "refs/tags/v${version}";
    sha256 = "K7whGWIukMrCqGaunHVuvr9k1EOTPSMb0x/A2JysVI0=";
  };

  cargoHash = "sha256-itwU6JIxDbem93KIpjWyKBiZhQP62D9h8ohIcMD14+0=";

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
    maintainers = with maintainers; [ johnrtitor toastal ];
    mainProgram = "lightningcss";
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
