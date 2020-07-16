{ stdenv, buildGoPackage, fetchFromGitHub, nixosTests }:

buildGoPackage rec {
  pname = "blackbox_exporter";
  version = "0.17.0";
  rev = version;

  goPackagePath = "github.com/prometheus/blackbox_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "00ganz6wfwyb9avkp2fr4bwpzvfiffsmpgndl8zp80bk7m1b3mnz";
  };

  # dns-lookup is performed for the tests
  doCheck = false;

  passthru.tests = { inherit (nixosTests.prometheus-exporters) blackbox; };

  meta = with stdenv.lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz willibutz Frostman ];
    platforms = platforms.unix;
  };
}
