{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ping-exporter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    rev = version;
    hash = "sha256-ttlsz0yS4vIfQLTKQ/aiIm/vg6bwnbUlM1aku9RMXXU=";
  };

  vendorHash = "sha256-ZTrQNtpXTf+3oPv8zoVm6ZKWzAvRsAj96csoKJKxu3k=";

  meta = with lib; {
    description = "Prometheus exporter for ICMP echo requests";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ nudelsalat ];
  };
}
