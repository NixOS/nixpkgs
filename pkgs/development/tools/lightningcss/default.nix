{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "v${version}";
    sha256 = "sha256-Mr3sqPrP9fIuQrE+XtDe5lu8dGwYNtKElfxFvLIllb4=";
  };

  cargoSha256 = "sha256-mF7bUcy5np/odQvhz0PEsWWgWRL2k8X0VaO9y1pDtzE=";

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
