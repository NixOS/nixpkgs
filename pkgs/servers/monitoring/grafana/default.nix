{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "4.1.1";
  ts = "1484211277";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "028s8fq8akv509kqw49865qpccxmhskaxcm51nn3c0i7vask2ivs";
  };

  srcStatic = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/grafana-${version}-${ts}.linux-x64.tar.gz";
    sha256 = "1srscjlm9m08z7shydhkl4wnhv19by7pqfd7qvbvz2v3d5slqiji";
  };

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";
  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $bin/share/grafana
    mv grafana-*/{public,conf,vendor} $bin/share/grafana/
    ln -sf ${phantomjs2}/bin/phantomjs $bin/share/grafana/vendor/phantomjs/phantomjs
  '';

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = http://grafana.org/;
    maintainers = with maintainers; [ offline fpletz ];
    platforms = platforms.linux;
  };
}
