{ rustPlatform, fetchFromGitHub, lib, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8Vfi/lHkaUvp6szSrqHaewXUWZ9Rb0oQdc8tuBFlvLI=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-3HhNFcNo/TNnAOLARtVnN/Moh2/8cdW7cn7MTahR18g=";

  cargoTestFlags = [
    "--package viceroy-lib"
  ];

  meta = with lib; {
    description = "Viceroy provides local testing for developers working with Compute@Edge";
    mainProgram = "viceroy";
    homepage = "https://github.com/fastly/Viceroy";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre shyim ];
    platforms = platforms.unix;
  };
}
