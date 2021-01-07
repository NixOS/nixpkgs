{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  name = "wakatime-exporter";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "MacroPower";
    repo = "wakatime_exporter";
    rev = version;
    sha256 = "14gbpm3kdhrk53xvlivsgzj048gkjv2pl1cmqqji56z1gp5kxfs7";
  };

  vendorSha256 = null;

  meta = with stdenv.lib; {
    description = "A Prometheus exporter for Wakatime statistics";
    homepage = "https//github.com/MacroPower/wakatime_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ djanatyn ];
  };
}
