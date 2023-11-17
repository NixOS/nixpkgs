{ lib
, buildGo120Module
, fetchFromGitHub
, testers
, wireproxy
}:

buildGo120Module rec {
  pname = "wireproxy";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "pufferffish";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-Sy8jApnU3dpsXi5vWyEY6D250xpG73aByNZ/pSg90l0=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-LBLEb2oVi5ILNtoOtmJZ7NC7hMvLZcexYAxwmb4iUBo=";

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
