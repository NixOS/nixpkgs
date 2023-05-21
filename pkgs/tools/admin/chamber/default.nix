{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1alRyAwT+vlzj7L6KG62R7PRKbMkevowUdD6he4ZQ/I=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-pyC2iMGx1seSBR3f316oNM0YiN3y1489uybpgHyN8NM=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
