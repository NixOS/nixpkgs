{ stdenv, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "nginxlog_exporter";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "martin-helmich";
    repo = "prometheus-nginxlog-exporter";
    rev = "v${version}";
    sha256 = "1kqyjw5yqgjb8xa5irdhpqvwp1qhba6igpc23n2qljhbh0aybkbq";
  };

  vendorSha256 = "130hq19y890amxhjywg5blassl8br2p9d62aai8fj839p3p2a7zp";

  subPackages = [ "." ];

  runVend = true;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginxlog; };

  meta = with stdenv.lib; {
    description = "Export metrics from Nginx access log files to Prometheus";
    homepage = "https://github.com/martin-helmich/prometheus-nginxlog-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ mmahut ];
  };
}
