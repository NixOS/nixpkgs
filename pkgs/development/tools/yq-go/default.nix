{ lib, buildGoModule, fetchFromGitHub, installShellFiles, runCommand, yq-go }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.12.1";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${version}";
    sha256 = "sha256-3L4SM698SJvHw1eXxxxL9OehDqQ6Al1XBL2WRG49PZU=";
  };

  vendorSha256 = "sha256-u7elWOW/tz1ISM/KC1njkZmPi8AEEssZ5QtxK/+1/1I=";

  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    for shell in bash fish zsh; do
      $out/bin/yq shell-completion $shell > yq.$shell
      installShellCompletion yq.$shell
    done
  '';

  passthru.tests = {
    simple = runCommand "${pname}-test" {} ''
      echo "test: 1" | ${yq-go}/bin/yq eval -j > $out
      [ "$(cat $out | tr -d $'\n ')" = '{"test":1}' ]
    '';
  };

  meta = with lib; {
    description = "Portable command-line YAML processor";
    homepage = "https://mikefarah.gitbook.io/yq/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.lewo ];
  };
}
