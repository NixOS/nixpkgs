{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "VictoriaMetrics";
  version = "1.52.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1sqzpr48sylgiy4zaf3f8hnwzv7imf57bxg6sin9lv291ybhxs68";
  };

  vendorSha256 = null;

  buildFlagsArray = [ "-ldflags=-s -w -X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}" ];

  passthru.tests = { inherit (nixosTests) victoriametrics; };

  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
  };
}
