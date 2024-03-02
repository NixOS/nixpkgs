{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cranky";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "ericseppanen";
    repo = "cargo-cranky";
    rev = "v${version}";
    hash = "sha256-3ARl3z+2nz05UaKf8ChN6mvPY2qMjUNxGnGJ1P0xkas=";
  };

  cargoHash = "sha256-jmyrtaJTdZlffC7i5k7z9BEsHAs1rPTCs2/jgq1Jt6Y=";

  meta = with lib; {
    description = "An easy to configure wrapper for Rust's clippy";
    homepage = "https://github.com/ericseppanen/cargo-cranky";
    changelog = "https://github.com/ericseppanen/cargo-cranky/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
