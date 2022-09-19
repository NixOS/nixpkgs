{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "v${version}";
    sha256 = "sha256-VRRSi4VF58E+d8cpX/shb4lBVBeTXHAaHJriTYYte/8=";
  };

  cargoSha256 = "sha256-duGCc+tWJ2J4wJL2ErZ3bGslxBERH0Xrb2taVaEOdas=";

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
