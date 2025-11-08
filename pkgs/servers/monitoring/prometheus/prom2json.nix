{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prom2json";
  version = "1.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "sha256-Zd3p1anHleKAkFcHEx7tgpxjTlb5OvdWXFNNyfJ63+w=";
  };

  vendorHash = "sha256-PZXuhPpO02ix88RtBpsGaQxgQNVn+LW09rrN66+mCpw=";

  meta = with lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    mainProgram = "prom2json";
    homepage = "https://github.com/prometheus/prom2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
