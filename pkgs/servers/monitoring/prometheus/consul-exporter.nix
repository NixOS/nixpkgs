{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "consul_exporter";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "consul_exporter";
    rev = "refs/tags/v${version}";
    hash = "sha256-cB3tpRa2sZBte5Rk7v9rvxvuRh2Ff3vPxmMYwhxxPSA=";
  };

  vendorHash = "sha256-naEbalwVRUFW2wRU3gxb/Zeu4oSnO6+bOZimxaySSyA=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Prometheus exporter for Consul metrics";
    mainProgram = "consul_exporter";
    homepage = "https://github.com/prometheus/consul_exporter";
    changelog = "https://github.com/prometheus/consul_exporter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ hectorj ];
  };
}
