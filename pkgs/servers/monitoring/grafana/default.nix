{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "5.1.2";
  name = "grafana-${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "0iw0mr6m99z6vy9mz9fdhmn4fxi359n3ns71bm5a71np8lf4qs36";
  };

  srcStatic = fetchurl {
    url = "https://grafana-releases.s3.amazonaws.com/release/grafana-${version}.linux-x64.tar.gz";
    sha256 = "18bqmvyfjkvkrdbxa989aa6c7ri3b4wdb7ai543hiaz00s9mnpzm";
  };

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";
  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $bin/share/grafana
    mv grafana-*/{public,conf,tools} $bin/share/grafana/
    ln -sf ${phantomjs2}/bin/phantomjs $bin/share/grafana/tools/phantomjs/phantomjs
  '';

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = https://grafana.org/;
    maintainers = with maintainers; [ offline fpletz willibutz ];
    platforms = platforms.linux;
  };
}
