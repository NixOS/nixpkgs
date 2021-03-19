{ lib, buildGoModule, fetchurl, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "grafana";
  version = "7.4.5";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "10pnwd4d19ry7w2x46acc3j8gjn73b45fzc579gz1hc8hx2b3s0s";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "1x9jx3ww37cn6r6cn6gqlavmllxydks23vm8w4934bv8zppj1zwz";
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
