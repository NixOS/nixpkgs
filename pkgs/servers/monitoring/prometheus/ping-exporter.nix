{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ping-exporter";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    rev = version;
    hash = "sha256-H+HcwDMnRgvEnbaI/tcS457Ir2Xtq30g44EYo4UPCE0=";
  };

  vendorHash = "sha256-bEJstamu0+EfHL2cduWb/iDeYCp8tzGCS2Lvc7Onp48=";

  meta = {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nudelsalat ];
  };
}
