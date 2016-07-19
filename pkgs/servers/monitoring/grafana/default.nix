{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "3.1.0";
  ts = "1468321182";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "1p3qp3p4wsb7m2lvdcrc1wz5mxqwqsj5xfqp28hkbfdqh3lblh42";
  };

  srcStatic = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/grafana-${version}-${ts}.linux-x64.tar.gz";
    sha256 = "174w0bx5cqriy77dyk9xsnmdskykzmgbyjczwb5kkp6j8vp7b0fs";
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
