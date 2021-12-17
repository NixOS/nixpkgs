{ lib, rustPlatform, fetchFromGitHub, stdenv, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-9Zov1XTU02TjQ707Z/Muv70AGtQL03V1G3suabY3D48=";
  };

  cargoSha256 = "sha256-toWzjfHU5ce/50kCbuxj6sIG2R3i8q9HBcIzlwW0C9A=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description =
      "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ xrelkd ];
  };
}
