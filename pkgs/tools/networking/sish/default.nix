{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  sish,
}:

buildGoModule rec {
  pname = "sish";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = "sish";
    rev = "refs/tags/v${version}";
    hash = "sha256-70FKq36q/wNMEmaFOXY9gt24gXXbdpQJB1F7wQwYigE=";
  };

  vendorHash = "sha256-hlwJE31osz9MgZ0vCx4L6vo4PuGh0NgiPJgDq65fZ4U=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/antoniomika/sish/cmd.Commit=${src.rev}"
    "-X=github.com/antoniomika/sish/cmd.Date=1970-01-01"
    "-X=github.com/antoniomika/sish/cmd.Version=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = sish;
    };
  };

  meta = with lib; {
    description = "HTTP(S)/WS(S)/TCP Tunnels to localhost";
    homepage = "https://github.com/antoniomika/sish";
    changelog = "https://github.com/antoniomika/sish/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "sish";
  };
}
