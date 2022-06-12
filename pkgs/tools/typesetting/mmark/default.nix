{ lib, buildGoModule, fetchFromGitHub, testers, mmark }:

buildGoModule rec {
  pname = "mmark";
  version = "2.2.25";

  src = fetchFromGitHub {
    owner = "mmarkdown";
    repo = "mmark";
    rev = "v${version}";
    sha256 = "sha256-9XjNTbsB4kh7YpjUnTzSXypw9r4ZyR7GALTrYebRKAg=";
  };

  vendorSha256 = "sha256-uHphMy9OVnLD6IBqfMTyRlDyyTabzZC4Vn0628P+0F4=";

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
