{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "vmagent";
  version = "1.83.1";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    rev = "v${version}";
    sha256 = "sha256-SfLqvVExP7qc2IDW6sJ0ykVRzL79FRv6zEVXivLpaVk=";
  };

  ldflags = [ "-s" "-w" "-X github.com/VictoriaMetrics/VictoriaMetrics/lib/buildinfo.Version=${version}" ];

  vendorSha256 = null;

  subPackages = [ "app/vmagent" ];

  meta = with lib; {
    homepage = "https://github.com/VictoriaMetrics/VictoriaMetrics/tree/master/app/vmagent";
    description = "VictoriaMetrics metrics scraper";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nullx76 ];
  };
}
