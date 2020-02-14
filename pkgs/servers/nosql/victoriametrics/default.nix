{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "VictoriaMetrics";
  version = "1.32.5";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1i3l8bkii3x8wnq9a8yn48cchni5h0gy3rrpvg0jgm4kmm5dlq4y";
  };

  modSha256 = "0696p1hv5z3dvawizvw0yi4xzl41bsmszkdqayzb37nm5cfk8riq";
  meta = with lib; {
    homepage = "https://victoriametrics.com/";
    description = "fast, cost-effective and scalable time series database, long-term remote storage for Prometheus";
    license = licenses.asl20;
    maintainers = [ maintainers.yorickvp ];
  };
}
