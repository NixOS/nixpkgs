{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "netdata-go-plugins";
  version = "0.51.4";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    hash = "sha256-yYagbTrUpynvmd20MATQvsR+jZM7dhrQdfSjuayrZJI=";
  };

  vendorHash = "sha256-lKoFm+wch9/ZgDSNSgYUrOq/X8DUEuSAQ4cc8UGaJzU=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  postInstall = ''
    mkdir -p $out/lib/netdata/conf.d
    cp -r config/* $out/lib/netdata/conf.d
  '';

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = "https://github.com/netdata/go.d.plugin";
    license = licenses.gpl3;
    maintainers = [ ];
  };
}
