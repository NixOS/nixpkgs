{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-UkNO2uNiyN6xB74dNMiWZUCH6qq6P6u95wTq8xRvxsQ=";
  };

  cargoSha256 = "sha256-JTjPdTG8KGYVkiCkTqRiJyTpm7OpZkbW10EKSp9lLJ4=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
