{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "chezmoi";
<<<<<<< HEAD
  version = "2.38.0";
=======
  version = "2.33.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "twpayne";
    repo = "chezmoi";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-s8E+Nva/lsZ/jPzDuGRN0P8JOeJPUK6Xj6bHqiozwNA=";
  };

  vendorHash = "sha256-UFEpP5I++8+F8OTMqm5G6/2Kn31Q2U3+8g0deeLMWDc=";
=======
    hash = "sha256-/Dh410wloqwo6dC9YP4Ufr6E56dnHoi48QSiYMSqml0=";
  };

  vendorHash = "sha256-P6PbriempswIH2h1RBTuhtxcmPI5T5lKS9nXRotARa8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  ldflags = [
    "-s" "-w" "-X main.version=${version}" "-X main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash --name chezmoi.bash completions/chezmoi-completion.bash
    installShellCompletion --fish completions/chezmoi.fish
    installShellCompletion --zsh completions/chezmoi.zsh
  '';

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://www.chezmoi.io/";
    description = "Manage your dotfiles across multiple machines, securely";
    changelog = "https://github.com/twpayne/chezmoi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jhillyerd ];
  };
}
