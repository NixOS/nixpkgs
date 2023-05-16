{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-insta";
<<<<<<< HEAD
  version = "1.31.0";
=======
  version = "1.29.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mitsuhiko";
    repo = "insta";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-hQaVUBw8X60DW1Ox4GzO+OCWMHmVYuCkjH5x/sMULiE=";
  };

  sourceRoot = "${src.name}/cargo-insta";

  cargoHash = "sha256-q6Ups4SDGjT5Zc9ujhRpRdh3uWq99lizgA7gpPVSl+A=";
=======
    hash = "sha256-3fN7otTIAdn7Bs96IaboxY0DG381AjCV/KsDzv8xng8=";
  };

  sourceRoot = "source/cargo-insta";

  cargoHash = "sha256-zxf70F3x8eydQuUrrdoQljvmmTzS6ytxVlbHOCepxFg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "A Cargo subcommand for snapshot testing";
    homepage = "https://github.com/mitsuhiko/insta";
    changelog = "https://github.com/mitsuhiko/insta/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ figsoda oxalica matthiasbeyer ];
=======
    maintainers = with lib.maintainers; [ figsoda oxalica ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
