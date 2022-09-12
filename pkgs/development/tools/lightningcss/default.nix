{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "v${version}";
    sha256 = "sha256-6OitOUy5y00gOWzXxvPuVJQlvERayHG1RK7To9kx23s=";
  };

  cargoSha256 = "sha256-RFI/QrUixKy+sxIw1NUTjHT8oQJFEnWNbbuAA6Rh18Y=";

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
