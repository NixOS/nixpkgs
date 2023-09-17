{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ojwhRsJzcQBZ8rBhs1VtsDmc2KYlAr8MR3oShxxyDtY=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-zRZ0hFBzU3NLgwRVkcSIZAaaa6CKT8fJj0IIRxiMGGg=";

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
