{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-GjC8nc8gpYQ3v0IYJc6vz0809PD6kTWx/HE1UOhTYc0=";
  };

  vendorHash = "sha256-Xmmc30W1ZfMc7YSQswyCjw1KyDA5qi8W+kZ1L7cM3cQ=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "Tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.bsl11;
    maintainers = with maintainers; [ zimbatm ma27 techknowlogick qjoly ];
    changelog   = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
  };
}
