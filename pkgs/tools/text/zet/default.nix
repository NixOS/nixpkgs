{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "zet";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "yarrow";
    repo = "zet";
    rev = "v${version}";
    hash = "sha256-IjM+jSb+kdML0zZGuz9+9wrFzQCujn/bg9/vaTzMtUs=";
  };

  cargoHash = "sha256-kHIOsSR7ZxBzp4dtm2hbi8ddtlQ86x5EASk5HFmnhFo=";

  # tests fail with `--release`
  # https://github.com/yarrow/zet/pull/7
  checkType = "debug";

  meta = with lib; {
    description = "CLI utility to find the union, intersection, set difference, etc of files considered as sets of lines";
    mainProgram = "zet";
    homepage = "https://github.com/yarrow/zet";
    changelog = "https://github.com/yarrow/zet/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
