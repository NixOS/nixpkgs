{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.47";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-zbV0m9VezBO543uUvgazjvpbVUpQlJfasCI9b2aF+oA=";
  };

  cargoHash = "sha256-TuGGDdciupk7nCq8r2hTbTPj1q638T9kGzgYMZe1O4g=";

  meta = with lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
  };
}
