{ lib, rustPlatform, fetchFromGitHub, installShellFiles, nasm }:

rustPlatform.buildRustPackage rec {
  pname = "sic-image-cli";
<<<<<<< HEAD
  version = "0.22.3";
=======
  version = "0.22.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "foresterre";
    repo = "sic";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-gTKStoQakquJqBv4OLWC4/1FtV+Cvw0nN+dY6AH8TNw=";
  };

  cargoSha256 = "sha256-xYPSI0/I67vmMPRmJOlbDJ9gTdhViQmeo3XWGhWR91Y=";
=======
    sha256 = "sha256-Ph1pAJJmkkeMbWe3DtxAdvp7bshQIbgmqCI4uf84ZGw=";
  };

  cargoSha256 = "sha256-FzbGOakAZPui7XObdwLDOfYrgleuePUDSUFPGBRkQKQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles nasm ];

  postBuild = ''
    cargo run --example gen_completions
  '';

  postInstall = ''
    installShellCompletion sic.{bash,fish}
    installShellCompletion --zsh _sic
  '';

  meta = with lib; {
    description = "Accessible image processing and conversion from the terminal";
    homepage = "https://github.com/foresterre/sic";
    changelog = "https://github.com/foresterre/sic/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "sic";
  };
}
