{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "prom2json";
  version = "1.3.3";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "prom2json";
    sha256 = "sha256-VwJv2Y+YrlhLRx0lRPtHTzjvSz7GPfADCZibkQU6S1Y=";
  };

  vendorHash = "sha256-m9f3tCX21CMdcXcUcLFOxgs9oDR2Uaj5u22eJPDmpeE=";

  meta = with lib; {
    description = "Tool to scrape a Prometheus client and dump the result as JSON";
    mainProgram = "prom2json";
    homepage = "https://github.com/prometheus/prom2json";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley ];
  };
}
