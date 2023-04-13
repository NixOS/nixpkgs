{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QZtsL4siO/ydumHiJX9ely+04OKyEZ8ak/KFwDhU7q8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "avt-0.5.1" = "sha256-AhOhmWxrMCyEKSLU/CDOoyCS12wQqBIaEjZd6oUsKHU=";
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
