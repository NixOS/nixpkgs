{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "08qz9zfk19iwf8qfv7vmzvbl8w1vpjrry25w3pxsg93gyjw8v7mi";
  };

  vendorSha256 = "0qnfd47ykb6g28d3mnfncgmkvqd1myx47x563sxx4lcsq542q83n";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
