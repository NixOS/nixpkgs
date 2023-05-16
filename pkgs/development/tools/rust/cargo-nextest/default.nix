{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
<<<<<<< HEAD
  version = "0.9.57";
=======
  version = "0.9.52";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
<<<<<<< HEAD
    hash = "sha256-vtKe0cl9PxZgc1zUJQI1YCQm4cRHmzqlBEC4RGUxM44=";
  };

  cargoHash = "sha256-o7nuDoBpSst84jyAVfrE8pLoYcKMF922r39G+gruBUo=";
=======
    hash = "sha256-Sl3ax2s81LiXejb0QP1fnmByAjAl8/JosUnw/RjEff8=";
  };

  cargoHash = "sha256-H3MzVH3868wqT1/j827u13nvGbTti8ePoCtrVQHoSCY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = lib.optionals stdenv.isDarwin [ Security ];

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  # TODO: investigate some more why these tests fail in nix
  checkFlags = [
    "--skip=tests_integration::test_list"
    "--skip=tests_integration::test_relocated_run"
    "--skip=tests_integration::test_run"
  ];

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
<<<<<<< HEAD
    maintainers = with maintainers; [ ekleog figsoda matthiasbeyer ];
=======
    maintainers = with maintainers; [ ekleog figsoda ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
