{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topicctl";
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-ZvyMGtsmXnJUGUoC9UciqCpQJsbxykzeRDo+i4ni82o=";
  };

  vendorHash = "sha256-+mnnvdna1g6JE29weOJZmdO3jFp2a75dV9wK2XcWJ9s=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = with lib; {
    description = "Tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ];
    mainProgram = "topicctl";
  };
}
