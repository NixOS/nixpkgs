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

  vendorSha256 = "sha256-RtackQ4uJo1j2jePu9xd0idQBKbwBh4L2spiS2mRynw=";

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
