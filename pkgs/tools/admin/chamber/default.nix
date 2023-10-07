{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.13.3";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Pte2fOIuezFJ1Hz5MgjRDTIAMJ5r+LO1hKHc3sLu0W4=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-McicBVC2niLvP902monJwPMOrQKSum10zeHNcO32/M8=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
