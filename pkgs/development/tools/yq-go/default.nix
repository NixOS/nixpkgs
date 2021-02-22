{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = "v${version}";
    repo = "yq";
    sha256 = "sha256-9D00I34pfoiI5cqXjsVLTT6XbFUYxgGit0ZuYeWSEyE=";
  };

  vendorSha256 = "sha256-66ccHSKpl6yB/NVhZ1X0dv4wnGCJAMvZhpKu2vF+QT4=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/yq shell-completion $shell > yq.$shell
      installShellCompletion yq.$shell
    done
  '';

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}
