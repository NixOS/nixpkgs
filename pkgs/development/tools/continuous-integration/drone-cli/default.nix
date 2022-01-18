{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "1.5.0";
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "sha256-bYjEVmQ7lPd+Gn5cJwlzBQkMkLAXA1iSa1DXz/IM1Ss=";

  doCheck = false;

  ldflags = [
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "sha256-TFIGKTVrAMSOFEmu3afdDKBgyEwF2KIv3rt1fS6rCxw=";
  };

  meta = with lib; {
    mainProgram = "drone";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
