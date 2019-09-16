{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "blackbox_exporter";
  version = "0.15.0";
  rev = version;

  goPackagePath = "github.com/prometheus/blackbox_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "06llb37xpn5zjnqkw526vbk4mfdiwrv3yg7aw4365p3gz5dk085i";
  };

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP and ICMP";
    homepage = "https://github.com/prometheus/blackbox_exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ globin fpletz willibutz ];
    platforms = platforms.unix;
  };
}
