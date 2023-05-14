{ lib
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, stdenv
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "rye";
  version = "unstable-2023-04-23";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "rye";
    rev = "b3fe43a4e462d10784258cad03c19c9738367346";
    hash = "sha256-q9/VUWyrP/NsuLYY1+/5teYvDJGq646WbMXptnUUUyw=";
  };

  cargoHash = "sha256-eyJ6gXFVnSC1aEt5YLl5rFoa3+M73smu5wJdAN15HQM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optional stdenv.isDarwin SystemConfiguration;

  meta = with lib; {
    description = "A tool to easily manage python dependencies and environments";
    homepage = "https://github.com/mitsuhiko/rye";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
