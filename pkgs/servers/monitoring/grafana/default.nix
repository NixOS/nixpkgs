{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

buildGoModule rec {
  pname = "grafana";
  version = "7.0.2";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "0ijaljj4c5bvv6z2dzsdr3d1rbza4lw29hy6gh805d01aadyag18";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "1rfzzsv087pq0fnfz27sddrz29j06bm9m136mkwbhcic8csykndw";
  };

  vendorSha256 = "00xvpxhnvxdf030978paywl794mlmgqzd94b64hh67946acnbjcl";

  postPatch = ''
    substituteInPlace pkg/cmd/grafana-server/main.go \
      --replace 'var version = "5.0.0"'  'var version = "${version}"'
  '';

  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $out/share/grafana
    mv grafana-*/{public,conf,tools} $out/share/grafana/
  '';

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [ offline fpletz willibutz globin ma27 Frostman ];
    platforms = platforms.linux;
  };
}
