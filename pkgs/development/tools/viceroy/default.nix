{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenv,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "viceroy";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "fastly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0jED0Ju7ojqDxfEjZKmWuCfGR830/gJF5p+QtcVajIY=";
  };

  buildInputs = lib.optional stdenv.isDarwin Security;

  cargoHash = "sha256-rSZe/MrJlbB0oaAsKg38mEnS3pqe9Rk4/aoRuLlOUFc=";

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
