{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, testers
, zq
}:

buildGoModule rec {
  pname = "zq";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-er3BPQ10ERCIBn0xx0jjyMBybnUBMyX76tqYEYe2WYQ=";
  };

  vendorHash = "sha256-3PyyR9d5m33ohbcstREvTOtWwMIrbFNvFyBY1F+6R+4=";

  subPackages = [ "cmd/zq" ];

  ldflags = [ "-s" "-X" "github.com/brimdata/zed/cli.Version=${version}" ];

  passthru.tests = testers.testVersion { package = zq; };

  meta = with lib; {
    description = "A command-line tool for processing data in diverse input formats, providing search, analytics, and extensive transformations using the Zed language";
    homepage = "https://zed.brimdata.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ knl ];
  };
}
