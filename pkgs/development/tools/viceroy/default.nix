{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DeKqLbgHmk6034ItyBzWRXLSeOj3+h49bzf9IX3Aa00=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-g6XdHl/Jxa+kpIjvnaP/RtoByo5O4IDC+s8M4DfGU/8=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre shyim ];
    platforms = platforms.unix;
  };
}
