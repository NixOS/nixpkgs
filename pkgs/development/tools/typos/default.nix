{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "typos";
  version = "1.24.4";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nXWa8+kOIXCYgBB6lunb3kAqOPrCREdjWDd0ZIAHknQ=";
  };

  cargoHash = "sha256-j0eTXgjukYNxJrga1MJLPJDnM6UJjoNXZdu8E5Efe0k=";

  meta = with lib; {
    description = "Source code spell checker";
    mainProgram = "typos";
    homepage = "https://github.com/crate-ci/typos";
    changelog = "https://github.com/crate-ci/typos/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda mgttlinger ];
  };
}
