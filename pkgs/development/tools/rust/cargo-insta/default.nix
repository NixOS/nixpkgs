{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.31.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "refs/tags/${version}";
    hash = "sha256-hQaVUBw8X60DW1Ox4GzO+OCWMHmVYuCkjH5x/sMULiE=";
  };

  sourceRoot = "${src.name}/cargo-insta";

  cargoHash = "sha256-q6Ups4SDGjT5Zc9ujhRpRdh3uWq99lizgA7gpPVSl+A=";

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda oxalica matthiasbeyer ];
  };
}
