{ lib, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "vmagent";
  version = "1.85.3";

  src = fetchFromGitHub {
    owner = "VictoriaMetrics";
    repo = "VictoriaMetrics";
    rev = "v${version}";
    sha256 = "sha256-/p5oHxp1fVyUMjZ3vim9YKNhFqIACGa3KTYIv/k4MXg=";
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
