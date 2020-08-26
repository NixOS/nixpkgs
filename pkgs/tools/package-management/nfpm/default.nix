{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "1q4fzjlaiwsm028cwcw7xgcbdkccw18f2mf1vh7lz42l1bxy8bk4";
  };

  vendorSha256 = "1bsb05qhr9zm8yar8mdi3mw0i5ak1s5x0i8qkz5fd6wcqnsw2jjw";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
