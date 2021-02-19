{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "sha256-QMJKrM5IBDqNfdxYAaEzmZ8YFMPu2hB6jvl6R/7ORl8=";
  };

  vendorSha256 = "sha256-VTKnkMe0SB6sWRJTC4p6BMjH5qZ6LsSQnjuPFfOP/Eg=";

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
