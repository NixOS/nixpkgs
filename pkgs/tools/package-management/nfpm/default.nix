{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F3SDcO5E0d5/aEJLdy0fJqB6brwf4C9Imtk1R5zOT5A=";
  };

  vendorSha256 = "sha256-fGhe0EukTWk/4tGPiFMit7zBD4380AkgxrQ3pzImsFU=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
