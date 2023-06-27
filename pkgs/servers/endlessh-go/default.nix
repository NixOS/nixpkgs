{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "20230613";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    sha256 = "sha256-XJcl8w36ZfcYp+0JlSvDW0BoW5MNC8pmTLZgkYLobBU=";
  };

  vendorHash = "sha256-UsbuB4GsL9pteebAF2ybAt7GgEpY0z4O9zjSYEIamdQ=";

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
