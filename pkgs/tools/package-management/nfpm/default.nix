{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d92wwmvyk6sn3z61y1n9w4wydafra941s0cpbnkc7c9qkxiwwnb";
  };

  modSha256 = "04hcg1n8f1wxz7n1k91nfspkd1ca7v5xf4hjj3wiw55vmykzcsm5";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
