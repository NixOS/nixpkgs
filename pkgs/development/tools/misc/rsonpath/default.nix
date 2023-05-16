{ lib
<<<<<<< HEAD
, rustPlatform
, fetchFromGitHub
=======
, stdenv
, rustPlatform
, fetchFromGitHub
, withSimd ? stdenv.isx86_64
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "rsonpath";
<<<<<<< HEAD
  version = "0.8.0";
=======
  version = "0.4.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "v0ldek";
    repo = "rsonpath";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-WrapSvWoaBVxlpCxau70Et5K9tRs84xsXBDWsuoFI+E=";
  };

  cargoHash = "sha256-fGu6eypizOGHCiyAeH7nCLHyfVLMBPNU1xmqfVGhSzw=";

  cargoBuildFlags = [ "-p=rsonpath" ];
  cargoTestFlags = cargoBuildFlags;
=======
    hash = "sha256-F52IUTfQ2h5z0+WeLNCCmX8vre58ayncW4/lxIwo/T8=";
  };

  cargoHash = "sha256-WY6wXnPh0rgjSkNMWOeOCl//kHlDk0z6Gvnjax33nvE=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "default-optimizations"
  ] ++ lib.optionals withSimd [
    "simd"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Blazing fast Rust JSONPath query engine";
    homepage = "https://github.com/v0ldek/rsonpath";
    changelog = "https://github.com/v0ldek/rsonpath/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
<<<<<<< HEAD
    mainProgram = "rq";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
