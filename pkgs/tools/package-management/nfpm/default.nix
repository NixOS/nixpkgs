{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q0472kfsm7h9p1g7yvd9k62myv5db3shpmjv39cx9rkfn6z8482";
  };

  vendorSha256 = "07xg8cm7pqpnb96drcmzk7rj2dhfn4pd8vr2a7nxqizd3qk6d5bf";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}