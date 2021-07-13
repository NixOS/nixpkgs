{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prom2json";
  version = "1.3.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "09glf7br1a9k6j2hs94l2k4mlmlckdz5c9v6qg618c2nd4rk1mz6";
  };

  vendorSha256 = null;

  meta = with lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    homepage = "https://github.com/prometheus/prom2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
    platforms = platforms.unix;
  };
}
