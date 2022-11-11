{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, testers
, zq
}:

buildGoModule rec {
  pname = "zq";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-BK4LB37jr/9O0sjYgFtnEkbFqTsp/1+hcmCNMFDPiPM=";
  };

  vendorSha256 = "sha256-oAkQRUaEP/RNjpDH4U8XFVokf7KiLk0OWMX+U7qny70=";

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
