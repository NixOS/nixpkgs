{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agebox";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-W6/v5BIl+k6tMan/Wdua7mHKMsq23QZN13Cy24akJr4=";
  };

  vendorHash = "sha256-PLeNTlQ0OMcupfbVN/KGb0iJYf3Jbcevg8gTcKHpn8s=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
    mainProgram = "agebox";
  };
}
