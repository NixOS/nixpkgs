{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-oGEG9uGjZTpJjQBnVlffFpNc5sb7HyD/ibpnQUhtTH4=";
  };

  vendorHash = "sha256-vHVx9vFPvctWNzibfZlN7mEYngYd6q7s9gMIM0FX0Ao=";

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
    maintainers = with maintainers; [ cstrahan zimbatm ma27 techknowlogick qjoly ];
    changelog   = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
  };
}
