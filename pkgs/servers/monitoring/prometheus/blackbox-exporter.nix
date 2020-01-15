{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "blackbox_exporter";
  version = "0.14.0";
  rev = version;

  goPackagePath = "github.com/prometheus/blackbox_exporter";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "prometheus";
    repo = "blackbox_exporter";
    sha256 = "1v5n59p9jl6y1ka9mqp0ibx1kpcb3gbpl0i6bhqpbr154frmqm4x";
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
