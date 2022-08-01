{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topicctl";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-uuASiJXyYzQC+9TkoALKiygRrgoEeR2cFPDQeZ9pIQ4=";
  };

  vendorSha256 = "sha256-u5U6JnlkQOjzKjbwdKgJ2YAh8//x7H/F3PC/H60boZc=";

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
