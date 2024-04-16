{ lib
, buildGoModule
, fetchFromGitHub
, testers
, wireproxy
}:

buildGoModule rec {
  pname = "wireproxy";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "pufferffish";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-2gio+kyjIvaNjb/+M8M5YvbAPbQX+B9A/Qly2kyFZXw=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-u5/ppH+8mcR3AdPnA6vDFL4GwVzbUj679I4zBw80HU0=";

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
    mainProgram = "wireproxy";
  };
}
