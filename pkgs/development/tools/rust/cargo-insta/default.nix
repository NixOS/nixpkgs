{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "refs/tags/${version}";
    hash = "sha256-3fN7otTIAdn7Bs96IaboxY0DG381AjCV/KsDzv8xng8=";
  };

  sourceRoot = "source/cargo-insta";

  cargoHash = "sha256-zxf70F3x8eydQuUrrdoQljvmmTzS6ytxVlbHOCepxFg=";

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ figsoda oxalica ];
  };
}
