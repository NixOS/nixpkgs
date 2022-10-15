{ lib, buildGoModule, fetchFromGitHub, testers, mmark }:

buildGoModule rec {
  pname = "mmark";
  version = "2.2.30";

  src = fetchFromGitHub {
    owner = "mmarkdown";
    repo = "mmark";
    rev = "v${version}";
    sha256 = "sha256-14SGA3a72i+HYptTEpxf4YiLXZzZ1R/t1agvm3ie4g8=";
  };

  vendorSha256 = "sha256-GjR9cOGLB6URHQi+qcyNbP7rm0+y4wypvgUxgJzIgGQ=";

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = mmark;
  };

  meta = {
    description = "A powerful markdown processor in Go geared towards the IETF";
    homepage = "https://github.com/mmarkdown/mmark";
    license = with lib.licenses; bsd2;
    maintainers = with lib.maintainers; [ yrashk ];
    platforms = lib.platforms.unix;
  };
}
