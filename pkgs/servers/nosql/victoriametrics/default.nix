{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "VictoriaMetrics";
  version = "1.37.4";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "02jr0qz130jz7ncfch1jry0prd00669j53mlmpb6ky0xiz5y2zq1";
  };

  goPackagePath = "github.com/VictoriaMetrics/VictoriaMetrics";

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/lib/buildinfo.Version=${version}" ];

  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
  };
}
