{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "VictoriaMetrics";
  version = "1.59.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2i9rmk9aAnjTJY+w/NKJOaLX+tpkt3vG07iLCsSGzdU=";
  };

  vendorSha256 = null;

  ldflags = [ "-s" "-w" "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}" ];

  passthru.tests = { inherit (nixosTests) victoriametrics; };

  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
    changelog = "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/tag/v${version}";
    platforms = [ "x86_64-linux" ];
  };
}
