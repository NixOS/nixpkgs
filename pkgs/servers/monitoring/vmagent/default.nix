{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "vmagent";
  version = "1.100.0";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    rev = "v${version}";
    sha256 = "sha256-jrKTic80y8r/1wOR8Prqe9PG57yo8qQIGsobu0I4kTY=";
  };

  ldflags = [ "-s" "-w" "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}" ];

  vendorHash = null;

  subPackages = [ "app/vmagent" ];

  meta = with lib; {
    homepage = "https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmagent";
    description = "VictoriaMetrics metrics scraper";
    mainProgram = "vmagent";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nullx76 ];
  };
}
