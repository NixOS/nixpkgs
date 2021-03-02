{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B8bXZ5PjlZIly25jK23ODa+RYGDfxHR0Z2fpAjptgP8=";
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
