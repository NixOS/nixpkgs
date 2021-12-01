{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-wDuCmiQzyY/Ydr67fYb0yZaSWvuYwW91j0CoqbUFFpg=";
  };

  cargoSha256 = "sha256-5KCGXJzk5VStby/JzjXJvDSrhFlB8YJHMcQNL8GxkLI=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
