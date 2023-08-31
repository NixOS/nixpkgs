{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.65";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-fPrke89Nlr9Yj0bkB6HTwMymQsjAQ+5+o7iVPGH7Tyc=";
  };

  cargoHash = "sha256-Q7nBKdwZlL/HleuiniuvErGF6Avf58xR++cJ7PP8RME=";

  meta = with lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
  };
}
