{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "mmctl";
  version = "7.10.3";

  src = fetchFromGitHub {
    owner = "mattermost";
    repo = "mmctl";
    rev = "v${version}";
    sha256 = "sha256-ANoisFJnTEUgL0xKGaS19jqAHX3MT9RR4BO7hz/vm6E=";
  };

  vendorHash = null;

  checkPhase = "make test";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mattermost/mmctl/v6/commands.Version=${version}"
  ];

  meta = with lib; {
    description = "A remote CLI tool for Mattermost";
    homepage = "https://github.com/mattermost/mmctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ ppom ];
  };
}
