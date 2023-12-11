{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topicctl";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-vOcxgqP4M9E9PXaCvLlPuxuu4KaQCyDuw3xF3Bd74/Q=";
  };

  vendorHash = "sha256-5n1pj0xa6Eh4Azh35J/ys8cjFMUpSkS5KzidYvInvpA=";

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
    mainProgram = "topicctl";
  };
}
