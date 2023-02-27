{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "wireproxy";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "octeep";
    repo = "wireproxy";
    rev = "v${version}";
    hash = "sha256-5xyKmFxXYhrR8EbG1/ByD10lhkPT9Ky1lq+LL2djaao=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  vendorHash = "sha256-/LZs6N2m5nHx735Ug+PcM1I1ZL9f8VYEpd7Tt4WizMQ=";

  meta = with lib; {
    description = "Wireguard client that exposes itself as a socks5 proxy";
    homepage = "https://github.com/octeep/wireproxy";
    license = licenses.isc;
    maintainers = with maintainers; [ _3JlOy-PYCCKUi ];
  };
}
