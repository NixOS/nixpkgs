{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "4.6.3";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "18r35pwarbgamhd7m9z4wpx6x1ymd5qsymvfll58zcgivis6c32j";
  };

  srcStatic = fetchurl {
    url = "https://grafana-releases.s3.amazonaws.com/release/grafana-${version}.linux-x64.tar.gz";
    sha256 = "01f50w57n7p7if37rhj8zy0y0x84qajbxrrdcfrsbi2qi1kzfz03";
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
    homepage = https://grafana.org/;
    maintainers = with maintainers; [ offline fpletz willibutz ];
    platforms = platforms.linux;
  };
}
