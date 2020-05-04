{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "15dzivnndzsiw7g6qzccpk1hqb5amfn0zba1rzkvcslhl1y9gsfi";
  };

  modSha256 = "13gqvr1y1b2yi2iar0p8y9hpajgy5w9xp4az5n6b5xhzcbn19f2k";

  subPackages = [ "cmd/eksctl" ];

  buildFlags = [ "-tags netgo" "-tags release" ];

  postInstall = ''
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
