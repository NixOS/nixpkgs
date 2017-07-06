{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "blackbox_exporter-${version}";
  version = "0.5.0";
  rev = version;

  goPackagePath = "github.com/prometheus/blackbox_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "1q719q7xslksj9m5c5d8jmap9380nsrdc71yjyn70rimv8xmzfj1";
  };

  meta = with stdenv.lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = https://github.com/prometheus/blackbox_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.unix;
  };
}
