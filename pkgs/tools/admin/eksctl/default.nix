{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.57.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "sha256-5Y//OD/UsqDnM8MPVJghrc5SbVwBEG/Eu761QWy5xK8=";
  };

  vendorSha256 = "sha256-CQ7A4vwUrshKRZBdIJZlCXmcxS0O0CkE1tNkZskYu1E=";

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  buildFlags = [ "-tags netgo" "-tags release" ];

  buildFlagsArray = [
    "-ldflags=-s -w -X github.com/weaveworks/eksctl/pkg/version.gitCommit=${src.rev} -X github.com/weaveworks/eksctl/pkg/version.buildDate=19700101-00:00:00"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/eksctl completion $shell > eksctl.$shell
      installShellCompletion eksctl.$shell
    done
  '';

  meta = with lib; {
    description = "A CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ xrelkd Chili-Man ];
  };
}
