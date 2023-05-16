{ lib
<<<<<<< HEAD
=======
, stdenv
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
<<<<<<< HEAD
  version = "1.9.4";
=======
  version = "1.8.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-oGEG9uGjZTpJjQBnVlffFpNc5sb7HyD/ibpnQUhtTH4=";
  };

  vendorHash = "sha256-vHVx9vFPvctWNzibfZlN7mEYngYd6q7s9gMIM0FX0Ao=";
=======
    sha256 = "sha256-M37JFKAv1GMtMr0UQ8lFEcTuboSMmCQ29dr6OP07HB8=";
  };

  vendorHash = "sha256-uQQv89562bPOoKDu5qEEs+p+N8HPRmgFZKUc5YEsz/w=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.mpl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ cstrahan zimbatm ma27 techknowlogick qjoly ];
    changelog   = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
=======
    maintainers = with maintainers; [ cstrahan zimbatm ma27 techknowlogick ];
    changelog   = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
    platforms   = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
