{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "refs/tags/${version}";
    hash = "sha256-w/dxIQ7KRrn86PwiE/g5L9Gn8KszPF9u/zlwE/FYDu4=";
  };

  sourceRoot = "${src.name}/cargo-insta";

  cargoHash = "sha256-mEtmZ+wFo1WI1IMNYsVqSVScFDLdiXBbghH7c0l/3NQ=";

  meta = with lib; {
    description = "Cargo subcommand for snapshot testing";
    mainProgram = "cargo-insta";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda oxalica matthiasbeyer ];
  };
}
