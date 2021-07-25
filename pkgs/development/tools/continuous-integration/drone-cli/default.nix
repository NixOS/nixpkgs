{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  version = "1.3.0";
  pname = "drone-cli";
  revision = "v${version}";

  vendorSha256 = "sha256-I+UBa6gqkPRXNV72iyJcCBLYShZxMtHFHSK77mhDv+U=";

  doCheck = false;

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X main.version=${version}")
  '';

  src = fetchFromGitHub {
    owner = "drone";
    repo = "drone-cli";
    rev = revision;
    sha256 = "sha256-j6drDMxvAVfQ1aCFooc9g9HhMRMlFZXGZPiuJZKBbY4=";
  };

  meta = with lib; {
    maintainers = with maintainers; [ bricewge ];
    license = licenses.asl20;
    description = "Command line client for the Drone continuous integration server";
  };
}
