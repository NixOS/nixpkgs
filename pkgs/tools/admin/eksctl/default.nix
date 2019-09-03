{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "1h7fyxlwa9f9r08rpl05r62ap7h7viaqchldbnv7j3vs2j23k127";
  };

  modSha256 = "17bb1k18x1xfq9bi9qbm8pln6h6pkhaqzy07qdvnhinmspll1695";

  subPackages = [ "cmd/eksctl" ];

  buildFlags = [ "-tags netgo" "-tags release" ];

  postInstall =
  ''
    mkdir -p "$out/share/"{bash-completion/completions,zsh/site-functions}

    $out/bin/eksctl completion bash > "$out/share/bash-completion/completions/eksctl"
    $out/bin/eksctl completion zsh > "$out/share/zsh/site-functions/_eksctl"
  '';

  meta = with lib; {
    description = "A CLI for Amazon EKS";
    homepage = "https://github.com/weaveworks/eksctl";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ xrelkd ];
  };
}
