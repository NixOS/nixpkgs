{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s3sh4n12g7ylkpmxqjcpdw3gqhdjbh9r09h2rsrm30xr4qaqpng";
  };

  vendorSha256 = "0p2pibid2d761whfk7zgq230lyqi2f0wmfvxqkjzrd1sba40r9bp";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  buildFlagsArray = [
    "-ldflags=-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = teams.acme.members;
  };

  passthru.tests.lego = nixosTests.acme;
}
