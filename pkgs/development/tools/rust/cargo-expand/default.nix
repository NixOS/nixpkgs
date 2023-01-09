{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.37";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-BdaOtbZ+F1cgoZRmoQM/5Rzx4OUHmqSnsApeNfWz+J8=";
  };

  cargoHash = "sha256-2wD0QJFTW8cIv8S1JSgffBqlcPOVd151WuKlaZF+6aA=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
