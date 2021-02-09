{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "yq-go";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "mikefarah";
    rev = "v${version}";
    repo = "yq";
    sha256 = "sha256-ehr9mCUbwQQSLR0iYoiJ3Xvgu+7Ue9Xvru9kAUkPCuQ=";
  };

  vendorSha256 = "sha256-CUELy6ajaoVzomY5lMen24DFJke3IyFzqWYyF7sws5g=";

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
