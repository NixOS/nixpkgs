{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-P7QG4ldOJn83w5XxIzC1dhVmn2e/gcwHBT9cZiQmsbo=";
  };

  vendorHash = "sha256-KtMK6jZ9c84OVWJC1njgOh1U+wrFo4G6Qt/XfOFvIhE=";

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
