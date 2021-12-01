{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.10.6";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8VnFpzm5St0AYFzups2ILQ/MrQRZLQ1xY9JjlGVBmZk=";
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
