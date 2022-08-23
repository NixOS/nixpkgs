{ lib, buildGoModule, fetchFromGitHub, testers, mmark }:

buildGoModule rec {
  pname = "mmark";
  version = "2.2.26";

  src = fetchFromGitHub {
    owner = "mmarkdown";
    repo = "mmark";
    rev = "v${version}";
    sha256 = "sha256-DiT2MkVM2DWp8dVr8I3Qt6iymHJPW3VEIaX+ACrDVo8=";
  };

  vendorSha256 = "sha256-vhSrHh1wmIK3H5p5Q5QznSVainkZByrW+Nz81J9Va88=";

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
