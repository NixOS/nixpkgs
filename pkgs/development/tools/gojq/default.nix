{ lib, buildGoModule, fetchFromGitHub, testers, gojq }:

buildGoModule rec {
  pname = "gojq";
  version = "0.12.9";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AII3mC+JWOP0x4zf8FQdRhOmckPgY7BDRoKICCFkn9Q=";
  };

  proxyVendor = true;

  vendorSha256 = "sha256-kq9vfmST8M69yiWqzsM/ORG7F7ERtEv9dyfy8u3sWYk=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gojq;
  };

  meta = with lib; {
    description = "Pure Go implementation of jq";
    homepage = "https://github.com/itchyny/gojq";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
