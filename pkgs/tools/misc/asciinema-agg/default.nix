{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = pname;
    rev = "v${version}";
    sha256 = "15j7smkjv2z9vd7drdq83g40j986ny39ai6y9rnai3iljsycyvgs";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "vt-0.3.0" = "sha256-QyAMMRul95onSL73bTSFw7E0Ey3oU/9w96NFfn57SUA=";
    };
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "A command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    homepage = "https://github.com/asciinema/agg";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
