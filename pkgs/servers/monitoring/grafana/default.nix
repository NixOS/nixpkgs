{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomJsSupport ? false, phantomjs2 ? null }:

buildGoPackage rec {
  pname = "grafana";
  version = "6.6.2";

  goPackagePath = "github.com/grafana/grafana";

  excludedPackages = [ "release_publisher" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "0zbc9jcr3w7rwsv96csqaifn5d0b435wyrrajr5wzsmhljygvrcy";
  };

  srcStatic = fetchurl {
    url = "https://dl.grafana.com/oss/release/grafana-${version}.linux-amd64.tar.gz";
    sha256 = "1plijm7cy92k79ypcnxjmdf2vhlxa4dzwjyl9lkf2npm7kswswsl";
  };

  postPatch = ''
    substituteInPlace pkg/cmd/grafana-server/main.go \
      --replace 'var version = "5.0.0"'  'var version = "${version}"'
  '';

  preBuild = "export GOPATH=$GOPATH:$NIX_BUILD_TOP/go/src/${goPackagePath}/Godeps/_workspace";

  postInstall = ''
    tar -xvf $srcStatic
    mkdir -p $bin/share/grafana
    mv grafana-*/{public,conf,tools} $bin/share/grafana/
  '' + lib.optionalString phantomJsSupport ''
    ln -sf ${phantomjs2}/bin/phantomjs $bin/share/grafana/tools/phantomjs/phantomjs
  '';

  meta = with lib; {
    description = "Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB";
    license = licenses.asl20;
    homepage = "https://grafana.com";
    maintainers = with maintainers; [ offline fpletz willibutz globin ma27 ];
    platforms = platforms.linux;
  };
}
