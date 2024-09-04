{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "prom2json";
  version = "1.4.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "sha256-oOnrIGtNQqS/7XCKcFtzXskv7N6syNyS52pZMwrY5wU=";
  };

  vendorHash = "sha256-d+/38wUMFChuLlVb84DELRQylCDIqopzk2bw/yd5B/E=";

  meta = with lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    mainProgram = "prom2json";
    homepage = "https://github.com/prometheus/prom2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
