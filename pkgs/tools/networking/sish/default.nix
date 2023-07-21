{ lib
, buildGoModule
, fetchFromGitHub
, testers
, sish
}:

buildGoModule rec {
  pname = "sish";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6PCZtiXsDQfPZFw3r1n3rwgxigSnWgggHXzZdBT/fxA=";
  };

  vendorHash = "sha256-RnvkEUvL/bQTTTlg0RF0xjjvVniltequNKRD3z0H3O8=";

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
  };
}
