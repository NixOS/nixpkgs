{ lib, goPackages, fetchurl, fetchFromGitHub }:

goPackages.buildGoPackage rec {
  version = "2.6.0";
  name = "grafana-v${version}";
  goPackagePath = "github.com/grafana/grafana";
  subPackages = [ "./" ];

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "grafana";
    repo = "grafana";
    sha256 = "160jarvmfvrzpk8agbl44761qz4rw273d59jg6kzd0ghls03wipr";
  };

  srcStatic = fetchurl {
    url = "https://grafanarel.s3.amazonaws.com/builds/grafana-${version}.linux-x64.tar.gz";
    sha256 = "1i4aw5jvamgqfaanxlh3l83sn8xx10wpihciihvf7s3846s623ab";
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
    platforms = platforms.linux;
  };
}
