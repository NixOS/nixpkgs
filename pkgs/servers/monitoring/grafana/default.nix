{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "3.1.1";
  ts = "1470047149";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "066qypjl9i0yl9jgqxh2fk6m4scrf84sfdl7b1jxgyq3c7zdzyvk";
  };

  srcStatic = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/grafana-${version}-${ts}.linux-x64.tar.gz";
    sha256 = "0zywijk9lg7pzql28r8vswyjixkljfjznbqy7lp5wlq1mmihmxr0";
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
