{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.13.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "refs/tags/v${version}";
    hash = "sha256-qXLg/EZF2eU7BhILHO7Uu4juz0tVZLq37foQcSKv0P8=";
  };

  vendorHash = "sha256-ofPz9IX+4ylch6Qe0ksGZqrP5x6AktqF0JAs/hLBQo0=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [
    "cmd/gobgpd"
  ];

  meta = with lib; {
    description = "BGP implemented in Go";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
