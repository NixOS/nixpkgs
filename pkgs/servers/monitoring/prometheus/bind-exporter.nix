{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bind_exporter";
  version = "0.6.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus-community";
    repo = "bind_exporter";
    sha256 = "sha256-MZ+WjEtSTGsi+2iKSZ4Xy6gq+Zf7DZHolBiq3wop22A=";
  };

  vendorSha256 = "sha256-uTjY4Fx2GR6e/3nXKNcmjsWbDjnOnu/jOShXzMF+b3Q=";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = with lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
    platforms = platforms.unix;
  };
}
