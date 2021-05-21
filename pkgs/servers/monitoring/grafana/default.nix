{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "7.5.6";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "1683as90p4zkzhaj52vy60bcmpr77zynys87mjzh3s6ks3xfxn2x";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "1mywvm4d116y56rffiywk1hx6wxj1418gf7q0v0hfdlwk1lqi9nz";
  };

  vendorSha256 = "01a5v292x59fmayjkqnf4c8k8viasxr2s2khs4yrv6p829lx3hq2";

  # grafana-aws-sdk is specified with two versions which causes a problem later:
  # go: inconsistent vendoring in /build/source:
  #  github.com/grafana/grafana-aws-sdk@v0.3.0: is explicitly required in go.mod, but not marked as explicit in vendor/modules.txt
  # Remove the older one here to fix this.
  postPatch = ''
    substituteInPlace go.mod \
      --replace 'github.com/grafana/grafana-aws-sdk v0.3.0' ""

    substituteInPlace pkg/cmd/grafana-server/main.go \
      --replace 'var version = "5.0.0"'  'var version = "${version}"'
  '';

  # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/scripts/go
  # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/dashboard-schemas
  preBuild = ''
    rm -r dashboard-schemas scripts/go
  '';

  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $out/share/grafana
    mv grafana-*/{public,conf,tools} $out/share/grafana/
  '';

  passthru.tests = { inherit (nixosTests) grafana; };

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [ offline fpletz willibutz globin ma27 Frostman ];
    platforms = platforms.linux;
  };
}
