{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "1av5w32ia68j2xrw4m16mzm9jn6xlap93kwi8iqw0s6wgihzadds";
  };

  vendorSha256 = "13sc4yrzgx2sm98whibfy2kjia3yy9cdvibvhbvg2lz2spprjb9v";

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
    maintainers = with maintainers; [ xrelkd ];
  };
}
