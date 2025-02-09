{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "moar";
  version = "1.18.6";

  src = fetchFromGitHub {
    owner = "walles";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QQapWDTJkP0YuyNR8J1N2IEETG1BfkdWv40SPD/JKYg=";
  };

  vendorHash = "sha256-x6BeU6JDayCOi8T8+NvXZe59QmTaO9RAYwSiFlDPL/c=";

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
