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

  cargoSha256 = "sha256-ORSYIRcvnKFkJxEjiTUSa1gkfmiQs3EAVOpXePVgBPQ=";

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
