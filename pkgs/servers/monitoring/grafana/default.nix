{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "7.4.0";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "0mdk3f237gvyjw8fxppfwzs8smhrnrj5aqc2wsykclrl52h5mv2z";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "1dc03d5hg7f2s9lrqycxm08ry8plkx8lkrfm4q3gjk1cvf5zjwzd";
  };

  vendorSha256 = "0m39dw4raqzm7zxcbncdxf7br5j173czl62xsp94q4g2h719mc9a";

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
