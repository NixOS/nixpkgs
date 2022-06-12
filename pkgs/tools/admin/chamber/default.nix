{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.10.10";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W/yuCQ1kE300//if/H73ZEJh/r2vttJ0GotZkBZNM+4=";
  };

  CGO_ENABLED = 0;

  vendorSha256 = "sha256-XpLLolxWu9aMp1cyG4dUQk4YtknbIRMmBUdSeyY4PNk=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
