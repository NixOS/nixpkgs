{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0eihk5zekp7sJ8fj1P0FT/JXWZ79j0U/hw5fjlbAJEo=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-pSFeBA3ux90bCX9iIW6aTGMCytWW/euYHpYppIJoYGc=";

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
