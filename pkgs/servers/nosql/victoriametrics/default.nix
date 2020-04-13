{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "VictoriaMetrics";
  version = "1.34.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0isifyvbrv0f6l32dycka67cpnizwh2c9ns2q8pz6r2myzbdsf3s";
  };

  modSha256 = "0fr5yah4qicqjfgina1ghflaz8dlzsqk3rrpsvg5l68jb6l7nxkb";
  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
  };
}
