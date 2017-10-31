{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "bind_exporter-${version}";
  version = "20161221-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "4e1717c7cd5f31c47d0c37274464cbaabdd462ba";

  goPackagePath = "github.com/digitalocean/bind_exporter";

  src = fetchFromGitHub {
    inherit rev;
    owner = "digitalocean";
    repo = "bind_exporter";
    sha256 = "1nd6pc1z627w4x55vd42zfhlqxxjmfsa9lyn0g6qq19k4l85v1qm";
  };

  meta = with stdenv.lib; {
    description = "Prometheus exporter for bind9 server";
    homepage = https://github.com/digitalocean/bind_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ rtreffer ];
    platforms = platforms.unix;
  };
}
