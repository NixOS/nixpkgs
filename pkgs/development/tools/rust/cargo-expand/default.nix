{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.49";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-bytGq95E8Ku+rF+al8WJdx991qudh3/sC9DxwluwmZc=";
  };

  cargoHash = "sha256-zIBTgIbUoUtQ4yboiW3jIprfNTOfFdg7sEgrwdMRsX8=";

  meta = with lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
  };
}
