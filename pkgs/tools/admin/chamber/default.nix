{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule rec {
  pname = "chamber";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-O5J1U+nXY+zQN/6AXE334icmqPnUgAKFR/p2l/iRwyk=";
  };

  CGO_ENABLED = 0;

  vendorHash = "sha256-W6PCaGQtVpwDuHv/LGoo7ip1Fzs/tZk7k1CcA+K1Pp4=";

  ldflags = [ "-s" "-w" "-X main.Version=v${version}" ];

  meta = with lib; {
    description =
      "A tool for managing secrets by storing them in AWS SSM Parameter Store";
    homepage = "https://github.com/segmentio/chamber";
    license = licenses.mit;
    maintainers = with maintainers; [ kalekseev ];
  };
}
