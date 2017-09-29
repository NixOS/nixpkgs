{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "blackbox_exporter-${version}";
  version = "0.8.1";
  rev = version;

  goPackagePath = "github.com/prometheus/blackbox_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "1bnn1xa11593m66ihdnyka0ck8zmg4abvwdyy5fpnyx29g3ym4sd";
  };

  meta = with stdenv.lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = https://github.com/prometheus/blackbox_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz ];
    platforms = platforms.unix;
  };
}
