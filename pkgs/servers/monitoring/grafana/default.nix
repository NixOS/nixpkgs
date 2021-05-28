{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "7.2.0";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "1pzsg6kr5kq5767plji7m6ssy2z9jxjp9zp182baxjd634mmclcx";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "003sn06r94m68b6l91cjr3xr3i7hq54ay0gb562i6y5swrfkqqwz";
  };

  vendorSha256 = "1b33kibvfa1qgalqb9ngxqimcn92cy8sllsc81wc9gmz4giz9mn1";

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
