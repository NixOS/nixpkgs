{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ping-exporter";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    rev = version;
    hash = "sha256-3q9AFvtjCSQyqX+LV1MEFHJVPBHtG304zuPHJ12XteE=";
  };

  vendorHash = "sha256-v1WSx93MHVJZllp4MjTg4G9yqHD3CAiVReZ5Qu1Xv6E=";

  meta = with lib; {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ nudelsalat ];
  };
}
