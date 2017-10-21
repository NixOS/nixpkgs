{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "blackbox_exporter-${version}";
  version = "0.9.1";
  rev = version;

  goPackagePath = "github.com/prometheus/blackbox_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "03sc1h8jfxaw7c5d6lkj6x653zhxhh0v29n6db3319nsfx00nrag";
  };

  meta = with stdenv.lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = https://github.com/prometheus/blackbox_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.unix;
  };
}
