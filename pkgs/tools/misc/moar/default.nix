{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "moar";
  version = "1.23.8";

  src = fetchFromGitHub {
    owner = "walles";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AUcnApH8fSCFNEKIJkNOh3Q2I+G2U2QOATHmtI7vPts=";
  };

  vendorHash = "sha256-1u/2OlMX2FuZaxWnpU4n5r/4xKe+rK++GoCJiSq/BdE=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage ./moar.1
  '';

  ldflags = [
    "-s" "-w"
    "-X" "main.versionString=v${version}"
  ];

  meta = with lib; {
    description = "Nice-to-use pager for humans";
    homepage = "https://github.com/walles/moar";
    license = licenses.bsd2WithViews;
    mainProgram = "moar";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
