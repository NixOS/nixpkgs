{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-/ViyS7srbOoZJDvDCRoNYWkdCYi3F1Pr0gSSFF0M1ak=";
  };

  vendorHash = "sha256-JNOlMf+PIONokw5t2xhz1Y+b5VwRDG7BKODl8fHCcJY=";

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --zsh contrib/zsh-completion/_packer
  '';

  meta = with lib; {
    description = "A tool for creating identical machine images for multiple platforms from a single source configuration";
    homepage    = "https://www.packer.io";
    license     = licenses.bsl11;
    maintainers = with maintainers; [ zimbatm ma27 techknowlogick qjoly ];
    changelog   = "https://github.com/hashicorp/packer/blob/v${version}/CHANGELOG.md";
  };
}
