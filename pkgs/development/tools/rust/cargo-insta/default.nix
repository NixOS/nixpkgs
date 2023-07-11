{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "refs/tags/${version}";
    hash = "sha256-Gh0RdWCYIYhur+nuHx68B2LllInx5Lx+5GeooWkB4dc=";
  };

  sourceRoot = "source/cargo-insta";

  cargoHash = "sha256-bV8LzYIQuSDg8ZETzF28PTuonvI+2QsPn7uTF8kn4fA=";

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda oxalica ];
  };
}
