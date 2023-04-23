{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bind_exporter";
  version = "0.6.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus-community";
    repo = "bind_exporter";
    sha256 = "sha256-qyTfo4Pkp07v575p7SePwe/OfCZRVuHKGyaEQQOkYjk=";
  };

  vendorHash = "sha256-ZQKQY7budLH6eAusLMwSF5cLJ6QdiXLJc29xJk+XBxI=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = with lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
    platforms = platforms.unix;
  };
}
