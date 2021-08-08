{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.60.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "sha256-zRwdluwVi4hbDZGlRwhNWkeq05c2VTZ52KrxvyFIBio=";
  };

  vendorSha256 = "sha256-mapok/c3uh7xmLZnN5S9zavgxSOfytqtqxBScv4Ao8w=";

  doCheck = false;

  subPackages = [ "cmd/eksctl" ];

  tags = [ "netgo" "release" ];

  ldflags = [
    "-s" "-w" "-X github.com/weaveworks/eksctl/pkg/version.gitCommit=${src.rev}" "-X github.com/weaveworks/eksctl/pkg/version.buildDate=19700101-00:00:00"
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
