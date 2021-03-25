{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.6.2";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = "v${version}";
    repo = "yq";
    sha256 = "sha256-Hv1o1MzkpapmeIsZJ4peyG5kSHt0EXjTA+gE0iq1XF8=";
  };

  vendorSha256 = "sha256-vpvIl1lfaziuoHs+oDEIztufH1somphiBAn6qTaQaZw=";

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
