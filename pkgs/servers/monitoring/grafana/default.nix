{ lib, goPackages, fetchurl, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  version = "2.5.0";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";
  subPackages = [ "./" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "11m6jvls3gm9z8g27vxmfx84f22vyjff8bllz5lvpdizydry6zar";
  };

  srcStatic = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/grafana-${version}.linux-x64.tar.gz";
    sha256 = "1zih0nzlx1sszgc4b5gll4jvsq43ikx782vv991fgy79bb2a5snk";
  };

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";
  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $bin/share/grafana
    mv grafana-*/{public,conf} $bin/share/grafana/
  '';

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = http://grafana.org/;
    maintainers = with maintainers; [ offline ];
    platforms = with platforms; linux;
  };
}
