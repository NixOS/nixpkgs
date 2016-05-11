{ lib, goPackages, fetchurl, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  version = "3.0.1";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "1zykgf8xq7m040d4yljcbz23gh8ppaqnxj50ncj1cjyi5k88i3i9";
  };

  srcStatic = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/grafana-${version}-.linux-x64.tar.gz";
    sha256 = "14wq2cbf4djnwbbyfbhnwmwqpfh5g4yp1dckg5zzf2109ymkjrqd";
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
    maintainers = with maintainers; [ offline fpletz ];
    platforms = platforms.linux;
  };
}
