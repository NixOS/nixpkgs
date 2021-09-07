{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "1.3.1";
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "sha256-IlQ83lhRiobjvXa4FvavwLAXe7Bi7oLXRAr+1kvIHhc=";

  doCheck = false;

  ldflags = [
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "sha256-EUvwKQgQTX8wX9h/rMlCYuB0S/OhPo4Ynlz5QQOWJlU=";
  };

  meta = with lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
