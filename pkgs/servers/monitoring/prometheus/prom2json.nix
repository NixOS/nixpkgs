{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prom2json";
  version = "1.4.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "sha256-3A26xMXJv2MMpFoc0zKZdSLg9WCueIsKdRdyM2NsUJw=";
  };

  vendorHash = "sha256-2XZYc6byupFTR2HCAVSL3wLYWwuzkkhqegzZRTakcgI=";

  meta = {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    mainProgram = "prom2json";
    homepage = "https://github.com/prometheus/prom2json";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ benley ];
  };
}
