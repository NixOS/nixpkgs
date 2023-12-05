{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bind_exporter";
  version = "0.7.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus-community";
    repo = "bind_exporter";
    sha256 = "sha256-x/XGatlXCKo9cI92JzFItApsjuZAfZX+8IZRpy7PVUo=";
  };

  vendorHash = "sha256-f0ei/zotOj5ebURAOWUox/7J3jS2abQ5UgjninI9nRk=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = with lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
  };
}
