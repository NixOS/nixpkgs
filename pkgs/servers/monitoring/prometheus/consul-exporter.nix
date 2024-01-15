{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "consul_exporter";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-3aPLpTV+xuotpBYmRDfU3ewRRlmf7VUdh/u9/SLQDeE=";
  };

  vendorHash = "sha256-fsST29HGwJVLVSoAr8tNukW81iJtpb/oypwp5cH7oLQ=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Prometheus exporter for Consul metrics";
    homepage = "https://github.com/prometheus/consul_exporter";
    changelog = "https://github.com/prometheus/consul_exporter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
  };
}
