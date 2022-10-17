{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "1.5.0";
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "0hh079qvxs4bcf0yy42y6sb303wxxam5h2mz56irdl0q2vqkk0f0";

  doCheck = false;

  patches = [ ./0001-use-different-upstream-for-gomod.patch ];

  ldflags = [
    "-X main.version=${version}"
  ];

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone-cli";
    rev = revision;
    sha256 = "sha256-TFIGKTVrAMSOFEmu3afdDKBgyEwF2KIv3rt1fS6rCxw=";
  };

  meta = with lib; {
    mainProgram = "drone";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
