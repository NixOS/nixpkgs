{ lib, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "VictoriaMetrics";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "10da15i3rn11dxnh82czaa2f9a4c3vf1d8kgfayp0dl7xs1xqhsd";
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
