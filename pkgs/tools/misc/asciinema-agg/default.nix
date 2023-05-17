{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ozkC3jaM7Q0BKS7KrgN+sI6YU0996ioTgbrJ4uJ6/9E=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "avt-0.6.0" = "sha256-JA1Ln90Pew6m5YOZp8weOC9JdKJqjFG0PDPNL2kDWUc=";
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
