{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-LOm4d6SV5rlb7NovhSp7V0JIaOfHIZOqeIcpIvTsZsA=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-Pz+jA4uC/40mj5Jn/lB+XcoN/QSD23iLwsEowTUI0pg=";

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
