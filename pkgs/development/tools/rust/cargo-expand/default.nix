{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.32";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-5zWJsc0OKgQMp0PeCuL99RE/Uj5sudXRMITjoKniPqQ=";
  };

  cargoSha256 = "sha256-/euiu7WNFY89QU1BKFfOAn7k93dZpuwbS6u2A6MDsoM=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
