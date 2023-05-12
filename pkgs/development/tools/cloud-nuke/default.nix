{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "cloud-nuke";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TTGC2lvqG+RYsruNzo7GApT5HMJyG4aoT12Rju9hTmY=";
  };

  vendorHash = "sha256-DPJ6+akisNtMsbDdHWEWavZ2GJfeWjFIV6K+bV91FEY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "A tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
