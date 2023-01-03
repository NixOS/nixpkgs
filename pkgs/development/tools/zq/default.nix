{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, testers
, zq
}:

buildGoModule rec {
  pname = "zq";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-DVQoWam5szELJ3OeIKHYF0CBZ0AJlhuIJRrdhqmyhQM=";
  };

  vendorSha256 = "sha256-2zSSjAoeb+7Nk/dxpvp5P2/bSJXgkA0TieTQHK4ym1Y=";

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
