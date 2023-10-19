{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topicctl";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-VyzWaoGOGDtB4fe0Wa6ldeOSEN+Ihu8xapiHcHJos0w=";
  };

  vendorHash = "sha256-UJ7U9CfQHKgK7wfb8zqLZ7na4OBBZBYiGayII3RTaiQ=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = with lib; {
    description = "A tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ];
  };
}
