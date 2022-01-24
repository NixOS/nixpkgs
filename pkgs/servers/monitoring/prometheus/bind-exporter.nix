{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bind_exporter";
  version = "0.5.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus-community";
    repo = "bind_exporter";
    sha256 = "sha256-ta+uy0FUEMcL4SW1K3v2j2bfDRmdAIz42MKPsNj4FbA=";
  };

  vendorSha256 = "sha256-L0jZM83u423tiLf7kcqnXsQi7QBvNEXhuU+IwXXAhE0=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = with lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
    platforms = platforms.unix;
  };
}
