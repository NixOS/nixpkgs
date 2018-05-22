{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "5.1.3";
  name = "grafana-${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "09q4xrh4j02b8nrkskndahs039rhmcs8hrcgvnnpg36qqyvs1x0g";
  };

  srcStatic = fetchurl {
    url = "https://grafana-releases.s3.amazonaws.com/release/grafana-${version}.linux-x64.tar.gz";
    sha256 = "131dxpjnzhsjh6c0fp48jhxf5piy6wh287pfm2s7pm4ywq9m0q46";
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
