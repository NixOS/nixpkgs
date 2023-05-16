<<<<<<< HEAD
{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "eksctl";
  version = "0.156.0";
=======
{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.140.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-E50MtMrZy2lnMjoYV4MJF+0YGLmGEioOF74rldXdOPU=";
  };

  vendorHash = "sha256-maMORSR6ZAasUxAy4kXvua4C+/dWdZbDde2VIKSV8w4=";
=======
    hash = "sha256-Y7OrEbPIDnUri5LXOpyNI/fZ+Cxxxj9hTqEXGyVHwOw=";
  };

  vendorHash = "sha256-xS8MiH9ij+lKpew02pFNpYDhLRVGRzBBy3uMhyiJ0+U=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  tags = [ "netgo" "release" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/weaveworks/eksctl/pkg/version.gitCommit=${src.rev}"
    "-X github.com/weaveworks/eksctl/pkg/version.buildDate=19700101-00:00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd eksctl \
      --bash <($out/bin/eksctl completion bash) \
      --fish <($out/bin/eksctl completion fish) \
      --zsh  <($out/bin/eksctl completion zsh)
  '';

  meta = with lib; {
    description = "A CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd Chili-Man ];
<<<<<<< HEAD
    mainProgram = "eksctl";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
