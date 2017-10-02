{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "4.5.2";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "1sgrnk90hn99c1xq49al5n76j2qqfi7sjc6r2fr00gd7mxzbh1mg";
  };

  srcStatic = fetchurl {
    url = "https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-${version}.linux-x64.tar.gz";
    sha256 = "19l1abq8qklhsqq1z4mi08c9z139b8gfyay7pwp4xmjxfzpsff64";
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
