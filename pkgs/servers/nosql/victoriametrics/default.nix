{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "VictoriaMetrics";
  version = "1.40.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0dnzc7yrd91g67wkx0g1b0gi7918pi1hqv4mjlxi2ccs8phxkk7l";
  };

  goPackagePath = "github.com/VictoriaMetrics/VictoriaMetrics";

  buildFlagsArray = [ "-ldflags=-s -w -X ${goPackagePath}/lib/buildinfo.Version=${version}" ];

  passthru.tests = { inherit (nixosTests) victoriametrics; };

  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
  };
}
