{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "bind_exporter";
  version = "0.4.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus-community";
    repo = "bind_exporter";
    sha256 = "152xi6kf1wzb7663ixv27hsdbf1x6s51fdp85zhghg1y700ln63v";
  };

  vendorSha256 = "172aqrckkhlyhpkanrcs66m13p5qp4fd2w8xv02j2kqq13klwm1a";

  passthru.tests = { inherit (nixosTests.prometheus-exporters) bind; };

  meta = with lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = "https://github.com/digitalocean/bind_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
    platforms = platforms.unix;
  };
}
