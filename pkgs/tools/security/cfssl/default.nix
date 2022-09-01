{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "cfssl";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = "v${version}";
    sha256 = "sha256-cyriV6z904QlkDlP80CSpakISJn7S81/2fcspAf5uk4=";
  };

  subPackages = [
    "cmd/cfssl"
    "cmd/cfssljson"
    "cmd/cfssl-bundle"
    "cmd/cfssl-certinfo"
    "cmd/cfssl-newkey"
    "cmd/cfssl-scan"
    "cmd/multirootca"
    "cmd/mkbundle"
  ];

  vendorSha256 = null;

  doCheck = false;

  ldflags = [
    "-s" "-w"
    "-X github.com/cloudflare/cfssl/cli/version.version=v${version}"
  ];

  passthru.tests = { inherit (nixosTests) cfssl; };

  meta = with lib; {
    homepage = "https://cfssl.org/";
    description = "Cloudflare's PKI and TLS toolkit";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbrgm ];
  };
}
