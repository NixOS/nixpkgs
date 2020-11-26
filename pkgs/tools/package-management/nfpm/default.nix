{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j9b6kkhlw2sx6qwnxkhsk7bj9vm2vr0z1hj1jf257fxw9m2q6mz";
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
