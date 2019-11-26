{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nfpm";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wgp4bana38r385qgcm83fhqd053y5i9swh5cmnmbqjibx85g5r2";
  };

  modSha256 = "1d532nv76gzckq2a0nyr9xixbm3rr8d8vlzgdz6i61xsjakfm6ap";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "A simple deb and rpm packager written in Go";
    homepage = "https://github.com/goreleaser/nfpm";
    maintainers = [ maintainers.marsam ];
    license = licenses.mit;
  };
}
