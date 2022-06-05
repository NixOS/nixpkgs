{ lib, buildGoModule, fetchFromGitHub, testers, aws-rotate-key }:

buildGoModule rec {
  pname = "aws-rotate-key";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "Fullscreen";
    repo = "aws-rotate-key";
    rev = "v${version}";
    sha256 = "sha256-5kV87uQDSc/qpm79Pd2nXo/EcbMlhZqFYaw+gJQa2uo=";
  };

  vendorSha256 = "sha256-h7tmJx/Um1Cy/ojiFjoKCH/LcOwhGU8ADb5WwmrkkJM=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = aws-rotate-key;
  };

  meta = with lib; {
    description = "Easily rotate your AWS key";
    homepage = "https://github.com/Fullscreen/aws-rotate-key";
    license = licenses.mit;
    maintainers = [ maintainers.mbode ];
    platforms = platforms.unix;
  };
}
