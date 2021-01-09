{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qv7xw74hf4fzi7v40fpgjyf01dyz6665dmd2pacpd9n6klnr1h3";
  };

  vendorSha256 = "0mdh4qrafdxlqqh0kl7wil7w3g5p499qi3yiw8znjkd49g85ws3w";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
