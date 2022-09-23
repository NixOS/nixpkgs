{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "20220731";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    sha256 = "sha256-xV9VCbpd6JC/m3RXJt0v8WCCGs8UpZLvAv3bzPRrae4=";
  };

  vendorSha256 = "sha256-YGVLntDnOX55IoIHIn0z1K7V/PhRLruEASfAGQsTUkk=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "An implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
  };
}
