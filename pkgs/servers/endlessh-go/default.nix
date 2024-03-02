{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "20230625-3";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    sha256 = "sha256-ug01nwlUCKe7DkhSJJ9XUU4QHZeH0A2f/oH6wl2VzIc=";
  };

  vendorHash = "sha256-n7lzSLtR3bUslT6Q1khsFeofSvwuSaBv3n33+HIdssU=";

  ldflags = [ "-s" "-w" ];

  passthru.tests = nixosTests.endlessh-go;

  meta = with lib; {
    description = "An implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
    mainProgram = "endlessh-go";
  };
}
