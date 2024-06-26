{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "drone-runner-ssh";
  version = "unstable-2022-12-22";

  src = fetchFromGitHub {
    owner = "drone-runners";
    repo = pname;
    rev = "ee70745c60e070a7fac57d9cecc41252e7a3ff55";
    sha256 = "sha256-YUyhEA1kYIFLN+BI2A8PFeSgifoVNmNPKtdS58MwwVU=";
  };

  vendorHash = "sha256-Vj6ZmNwegKBVJPh6MsjtLMmX9WR76msuR2DPM8Qyhe0=";

  meta = with lib; {
    description = "Experimental Drone runner that executes a pipeline on a remote machine";
    homepage = "https://github.com/drone-runners/drone-runner-ssh";
    license = licenses.unfreeRedistributable;
    maintainers = teams.c3d2.members;
    mainProgram = "drone-runner-ssh";
  };
}
