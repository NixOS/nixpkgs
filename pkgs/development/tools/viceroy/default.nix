{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lFDhiBgJFCXE7/BzCuNFPmP8PYHCqu6jYqRNa+M4J8Q=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-HJXCNjWjO1GWIP46kqvq8mZVlYVvlG9ahxScpG3rfTA=";

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
