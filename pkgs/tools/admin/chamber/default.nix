{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BD4gtdlIh5IRgTtrCdEN+o5d00wZsczsH0JbdoFdg4o=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-Rk6doJqLD8ucU+mGDtteCyM/QvnzbIVnFmFW9b09560=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
    mainProgram = "chamber";
  };
}
