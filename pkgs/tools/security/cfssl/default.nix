{ lib, buildGoModule, fetchFromGitHub, go-rice }:

buildGoModule rec {
  pname = "cfssl";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "cfssl";
    rev = "v${version}";
    sha256 = "sha256-QY04MecjQTmrkPkWcLkXJWErtaw7esb6GnPIKGTJL34=";
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

  nativeBuildInputs = [ go-rice ];

  preBuild = ''
    pushd cli/serve
    rice embed-go
    popd
  '';

  ldflags = [
    "-s" "-w"
    "-X github.com/cloudflare/cfssl/cli/version.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://cfssl.org/";
    description = "Cloudflare's PKI and TLS toolkit";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbrgm ];
  };
}
