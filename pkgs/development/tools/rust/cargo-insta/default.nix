{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "refs/tags/${version}";
    hash = "sha256-s6d0q4K2UTG+BWzvH5KOAllzYAkEapEuDoiI9KQW31I=";
  };

  sourceRoot = "${src.name}/cargo-insta";

  cargoHash = "sha256-ZQUzoKE3OGaY22VYiku7GqjGN9jUNx09a0EcgCRzzcM=";

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
  };
}
