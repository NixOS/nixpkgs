{ lib, buildGoPackage, fetchurl, fetchFromGitHub, phantomjs2 }:

buildGoPackage rec {
  version = "4.2.0";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "0zzvdzakswqidxbsss98nfa8rw80r36f45yviai12xsns9jzmj7z";
  };

  srcStatic = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/grafana-${version}.linux-x64.tar.gz";
    sha256 = "1cs7ghkp13znz9yxv108770xjfsp8vks6xkzpqqhsjis5h5y0g9w";
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
