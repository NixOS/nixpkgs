{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "eksctl";
  version = "0.1.35";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "eksctl";
    rev = version;
    sha256 = "0b3s7vh85k68wawmsdp96q9l4yhikwhyjn1c7cwxys0aia4i8wkv";
  };

  goPackagePath = "github.com/weaveworks/eksctl";

  subPackages = [ "cmd/eksctl" ];

  buildFlags =
  ''
    -ldflags=-s
    -ldflags=-w
    -tags netgo
    -tags release
  '';

  postInstall =
  ''
    mkdir -p "$bin/share/"{bash-completion/completions,zsh/site-functions}
    $bin/bin/eksctl completion bash > "$bin/share/bash-completion/completions/eksctl"
    $bin/bin/eksctl completion zsh > "$bin/share/zsh/site-functions/_eksctl"
  '';

  meta = with lib; {
    description = "A CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
