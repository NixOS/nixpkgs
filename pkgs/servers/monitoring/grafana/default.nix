{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "7.4.1";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "11gvw8kdz7238jcaiyqk6i0ciy6plixljpzdajlabywgr9jam32g";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "1266vj8saf4nh5h6cz8axkk58g1mwgvc9c6caphj71dhvr3snw6i";
  };

  vendorSha256 = "0ig0f9pa3l0nj2fs8yz8h42y1j07xi9imk7kzmla6vav6s889grc";

  postPatch = ''
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
