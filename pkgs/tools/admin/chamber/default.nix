{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-zjVch0NzCmimydk7/Uz4FZhcgQD+9xV6H6sAtPnFhDE=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-1glSjsuHN7urlktxJ/vR/jfDgbVBWsui0bZWMhmJ50c=";

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
