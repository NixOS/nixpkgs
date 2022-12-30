{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nut-exporter";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
    sha256 = "sha256-pXC4DkuMyvNG8w/p5ku8hi6MhbF85PzVpFz+IExT9NU=";
  };

  vendorSha256 = "sha256-ji8JlEYChPBakt5y6+zcm1l04VzZ0/fjfGFJ9p+1KHE=";

  meta = with lib; {
    description = "Prometheus exporter for Network UPS Tools";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ jhh ];
  };
}
