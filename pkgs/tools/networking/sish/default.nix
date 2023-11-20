{ lib
, buildGoModule
, fetchFromGitHub
, testers
, sish
}:

buildGoModule rec {
  pname = "sish";
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "antoniomika";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dNwSMDEt142A0rP212bWBZSX2zhYgL94EJymOvegTa8=";
  };

  vendorHash = "sha256-XtN2RgegmKR/RDFBbHn9kpI1BxmF7jfu7LAwPVaAvEk=";

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
