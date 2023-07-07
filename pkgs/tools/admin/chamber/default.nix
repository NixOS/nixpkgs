{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F4JVAW6aKbEofTshF6vny5hnTFnfUKuRyc9zaUxSjG4=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-xFZmTsX5OrLu1AkKDHaa5N277J5dLGf5F9ATWirtnXY=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
