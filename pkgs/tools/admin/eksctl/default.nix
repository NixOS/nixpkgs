{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "1vmikblhr2r5vjq3mg8dmkz7i9y8560hnjq3ymmvinz644w19zp2";
  };

  vendorSha256 = "1lhs1h0x3ryq0bd5w9ny7i2j9d0x2904br1vlxy677w2xsa9213p";

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
