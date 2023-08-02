{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.13.2";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nFRDA0EHV1i9mcl1i5WpfhTNseU9E9jmlPd1xFbkCaM=";
  };

  vendorHash = "sha256-mjCxe4hCCIcjVDWVizqqqo6/kn8iS8s32urMtDD5yq4=";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = teams.acme.members;
  };

  passthru.tests.lego = nixosTests.acme;
}
