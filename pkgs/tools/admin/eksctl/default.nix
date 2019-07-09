{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "eksctl";
  version = "0.1.39";

  src = fetchFromGitHub {
    owner = "weaveworks";
    repo = "eksctl";
    rev = version;
    sha256 = "11y2pb5jn64v89a9hwi25rakrnsvhyjyr8kdrjk81d6hhrfkz3g0";
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
