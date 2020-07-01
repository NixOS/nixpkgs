{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "VictoriaMetrics";
  version = "1.37.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0p8fk73ydnhrdxgxr4b4xl84729rkkki38227xvxspx84j2fbhci";
  };

  goPackagePath = "github.com/VictoriaMetrics/VictoriaMetrics";

  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
  };
}
