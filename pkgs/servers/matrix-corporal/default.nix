{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "matrix-corporal";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "devture";
    repo = pname;
    rev = version;
    sha256 = "sha256-u1ppwy+t2ewAH0/+R6e0Ja5A3PQG/lUy2b6kgcMVj8E=";
  };

  ldflags = [
    "-s" "-w" "-X main.GitCommit=${version}" "-X main.GitBranch=${version}" "-X main.GitState=nixpkgs" "-X main.GitSummary=${version}" "-X main.Version=${version}"
  ];

  vendorSha256 = "sha256-YmUiGsg2UZfV6SHEPwnbmWPhGQ5teV+we9MBaJyrJr4=";

  meta = with lib; {
    homepage = "https://github.com/devture/matrix-corporal";
    description = "Reconciliator and gateway for a managed Matrix server";
    maintainers = with maintainers; [ dandellion ];
    license = licenses.agpl3Only;
  };
}
