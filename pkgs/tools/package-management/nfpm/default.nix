{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EIHEdU1H5XhhzuWJUEvnKNsuNV8CBJrHBlaZlSfrSro=";
  };

  vendorSha256 = "sha256-aSoryidfAfqPBpOtAXFJsq1ZcqJqpGiX3pZz5GpkKqQ=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
