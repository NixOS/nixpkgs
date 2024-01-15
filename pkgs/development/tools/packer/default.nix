{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "packer";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer";
    rev = "v${version}";
    hash = "sha256-pHqYO3a9JruOCbMbLLQ2BqS4bcCeaBf82cBxGVHgLoY=";
  };

  vendorHash = "sha256-ydG1nINW9uGYv5uNlJ6p8GHSkIW83qGpUAfRU+yQXmc=";

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
