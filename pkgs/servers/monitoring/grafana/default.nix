{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "4.3.1";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "1m291d6xx37llpkj48fn85r5qb2pbv3q0hpmypd0l0hc6hrkmazp";
  };

  srcStatic = fetchurl {
    url = "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${version}.linux-x64.tar.gz";
    sha256 = "17v5yizhd5jm32hf4qbz415g0ka3c41khc55pc5v2652b61glin0";
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
