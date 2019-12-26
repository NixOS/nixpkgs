{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "197lf6cb1maam1yxy29wgp4dkakaavmwqvq2d9i4qxhscalrdra5";
  };

  modSha256 = "04ba3dyfwlf0m6kn7yp7qyp3h2qdwp17y1f9pa79y3c6sd2nadk2";

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
