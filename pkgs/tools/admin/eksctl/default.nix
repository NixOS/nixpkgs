{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = pname;
    rev = version;
    sha256 = "1q7qcmipqq83wm44jn8r0ssvsd3qx8bg3qz0ksj136gf4rhkf59p";
  };

  modSha256 = "1lmkwx0r19c2wg9nm85k92nlxjzr8q917jf3f333yf3csfyiix2f";

  subPackages = [ "cmd/eksctl" ];

  buildFlags =
  ''
    -tags netgo
    -tags release
  '';

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
