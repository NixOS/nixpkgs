{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pgdajbphqfn430jwm052czz1d4ynl6n4z2wjzmblv7lwkbh9j3d";
  };

  vendorSha256 = "0x7r7qn4852q57fx5mcrw3aqdydmidk9g0hvj6apj81q77k5svqs";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
