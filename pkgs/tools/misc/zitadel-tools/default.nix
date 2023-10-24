{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zitadel-tools";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel-tools";
    rev = "v${version}";
    hash = "sha256-r9GEHpfDlpK98/dnsxjhUgWKn6vHQla8Z+jQUVrHGyo=";
  };

  vendorHash = "sha256-y2PYj0XRSgfiaYpeqAh4VR/+NKUPKd1c0w9pPCWsUrY=";

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Helper tools for zitadel";
    homepage = "https://github.com/zitadel/zitadel-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ janik ];
  };
}
