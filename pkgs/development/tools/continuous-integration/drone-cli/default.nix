{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "1.4.0";
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "sha256-v2ijRZ5xvYkL3YO7Xfgalzxzd9C5BKdaQF7VT5UoqOk=";

  doCheck = false;

  ldflags = [
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "sha256-+70PWHGd8AQP6ih0b/+VOIbJcF8tSOAO9wsGqQWX+bU=";
  };

  meta = with lib; {
    mainProgram = "drone";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
