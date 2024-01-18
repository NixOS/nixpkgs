{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.13.6";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jaD93q8s2uLb8jIvUBAnT76brDos46Wk06UKXAgHQGs=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-BkTC6sqitc1OHdQFlA2BtqxHI31ubBj2GRszs3YlWsA=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
