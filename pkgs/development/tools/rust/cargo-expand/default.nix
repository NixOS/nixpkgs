{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.38";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    sha256 = "sha256-n7GDvniwkyCYiu7/qw0TQsVsTZfjcSpkF2Qo/uO60e4=";
  };

  cargoHash = "sha256-oA+8bceow7Cdao9FhkXkfFyrCpgvR4NJHddevbhUFkA=";

  meta = with lib; {
    description = "A utility and Cargo subcommand designed to let people expand macros in their Rust source code";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ figsoda xrelkd ];
  };
}
