{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "refs/tags/v${version}";
    hash = "sha256-aVvzbWMh/r1k3AKDHipWkwEevYPj8Xfix8PfIMYXiTM=";
  };

  vendorHash = "sha256-9Vi8qrcFC2SazcGVgAf1vbKvxd8rTMgye63wSCaFonk=";

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
