{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "09r8qyc9gcc3slfldkxp91bkiyfgd6qh4di0dbnjggsqfncg34ra";
  };

  modSha256 = "0y222vxxs9aw17mhif4m0z35ks9xxv90ajk9am71x85sfvkglgl0";

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
