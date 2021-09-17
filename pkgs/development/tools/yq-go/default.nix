{ lib, buildGoModule, fetchFromGitHub, installShellFiles, runCommand, yq-go }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "mikefarah";
    repo = "yq";
    rev = "v${version}";
    sha256 = "sha256-9yKCFEtGg6TiHo3PGobVzQSbqc27ptKhH+2WgbLKXRI=";
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
