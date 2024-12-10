{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VzeHebbeqW+Tn1ZEiJRdfxJlWLg9Gf5+5dAaqPoTtP0=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  cargoHash = "sha256-WQzY4fh+plyJCBkJJ/4kgUZ8bEWzL5CVGX67LTu4rnI=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [
      ereslibre
      shyim
    ];
    platforms = platforms.unix;
  };
}
