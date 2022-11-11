{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "20221012";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    sha256 = "sha256-qgwOaqRyMiN3+vnwzwNet7jMQzgmFb09AVfYFwCAQJI=";
  };

  vendorSha256 = "sha256-8W0yh+/FPIf6M5JipwbpLseKEdo4uVRmtsYYqfkwENU=";

  ldflags = [ "-s" "-w" ];

  passthru.tests = nixosTests.endlessh-go;

  meta = with lib; {
    description = "An implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
  };
}
