{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "1.6.0";
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "sha256-0vHOPuSn7eczlUeCTz+SOMuDdRQTzw/TnH1rt/ltWOQ=";

  doCheck = false;

  patches = [ ./0001-use-different-upstream-for-gomod.patch ];

  ldflags = [
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone-cli";
    rev = revision;
    sha256 = "sha256-TVOj1C5X3fTRZF29hId13LjkkwaAFntlozpmYVUfVJI=";
  };

  meta = with lib; {
    mainProgram = "drone";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
