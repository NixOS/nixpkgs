{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "7.3.7";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "134x2jqrczp5qfa2rmqc7jikv3w258kks532jp1qi65qk7w7jhb9";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "052r9gajggd9jlwnl82hq0jflhlz7cbdflkjapq4nx3rpnfscqgp";
  };

  vendorSha256 = "0474d5y40q7i7k1gm1k7ac1dqhizvqql8w9nn44qxb7g2w2bfqiv";

  postPatch = ''
    substituteInPlace pkg/cmd/grafana-server/main.go \
      --replace 'var version = "5.0.0"'  'var version = "${version}"'
  '';

  # fixes build failure with go 1.15:
  # main module (github.com/grafana/grafana) does not contain package github.com/grafana/grafana/scripts/go
  preBuild = ''
    rm -rf scripts/go
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
