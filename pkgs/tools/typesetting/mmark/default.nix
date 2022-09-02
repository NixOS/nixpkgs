{ lib, buildGoModule, fetchFromGitHub, testers, mmark }:

buildGoModule rec {
  pname = "mmark";
  version = "2.2.28";

  src = fetchFromGitHub {
    owner = "mmarkdown";
    repo = "mmark";
    rev = "v${version}";
    sha256 = "sha256-3+Wocaoma3dQnrqBcEWcTC+LNmDxssvmiDrir0gANyo=";
  };

  vendorSha256 = "sha256-W1MOjV1P6jV9K6mdj8a+T2UiffgpiOpBKo9BI07UOz0=";

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
