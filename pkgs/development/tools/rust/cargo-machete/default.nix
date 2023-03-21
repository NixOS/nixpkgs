{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-machete";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "bnjbvr";
    repo = "cargo-machete";
    rev = "v${version}";
    hash = "sha256-AOi4SnFkt82iQIP3bp/9JIaYiqjiEjKvJKUvrLQJTX8=";
  };

  cargoHash = "sha256-Q/2py0zgCYgnxFpcJD5PfNfIfIEUjtjFPjxDe25f0BQ=";

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "A Cargo tool that detects unused dependencies in Rust projects";
    homepage = "https://github.com/bnjbvr/cargo-machete";
    changelog = "https://github.com/bnjbvr/cargo-machete/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
