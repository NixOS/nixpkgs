{ lib
, buildGoModule
, fetchFromGitHub
, testers
, wireproxy
}:

buildGoModule rec {
  pname = "wireproxy";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "pufferffish";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-lMTlocKtOg82dH8XU+bIgPhico3mueLAuTspAY88GFI=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-V9W7Z8vgPdudNivfmGzJe1f6ebrZEqlG4AdIf2NNGrY=";

  passthru.tests.version = testers.testVersion {
    package = wireproxy;
    command = "wireproxy --version";
    version = src.rev;
  };

  meta = with lib; {
    description = "Wireguard client that exposes itself as a socks5 proxy";
    homepage = "https://github.com/octeep/wireproxy";
    license = licenses.isc;
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
