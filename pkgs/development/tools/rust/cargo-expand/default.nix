{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-6Wm/qnrSUswWnXt6CPUJUvqNj06eSYuYOmGhbpO1hvo=";
  };

  cargoSha256 = "sha256-1+3NMfUhL5sPu92r+B0DRmJ03ZREkFZHjMjvabLyFgs=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
