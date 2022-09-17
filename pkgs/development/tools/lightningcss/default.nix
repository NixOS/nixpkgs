{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "v${version}";
    sha256 = "sha256-r/j8ZQo3hbM65TNAaC2BFMfuD56/8/QRUjcD7MRQN9c=";
  };

  cargoSha256 = "sha256-J6Z7PARdXNDiHECjutjFcx+Yhwz7cBZfhusukSDgWa8=";

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
