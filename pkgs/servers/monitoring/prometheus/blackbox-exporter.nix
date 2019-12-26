{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "blackbox_exporter";
  version = "0.16.0";
  rev = version;

  goPackagePath = "github.com/prometheus/blackbox_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "1zbf3ljasv0r91rrmk3mj5nhimaf7xg3aih1ldz27rh5yww7gyzg";
  };

  # dns-lookup is performed for the tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz willibutz ];
    platforms = platforms.unix;
  };
}
