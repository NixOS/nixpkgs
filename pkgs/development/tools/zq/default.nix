{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, testers
, zq
}:

buildGoModule rec {
  pname = "zq";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "zed";
    rev = "v${version}";
    hash = "sha256-ias2HKwZo5Q/0M4YZI4wLgzMVWmannruXlhp8IsOuyU=";
  };

  vendorHash = "sha256-h5NYx6xhIh4i/tS5cGHXBomnVZCUn8jJuzL6k1+IdKk=";

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
