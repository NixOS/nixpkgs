{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cutter-1.04";

  src = fetchurl {
    url = "http://www.digitage.co.uk/digitage/files/cutter/${name}.tgz";
    sha256 = "100iy31a3njif6vh9gfsqrm14hac05rrflla275gd4rkxdlnqcqv";
  };

  installPhase = ''
    install -D -m 0755 cutter $out/bin/tcp-cutter
  '';

  meta = with stdenv.lib; {
    description = "TCP/IP Connection cutting on Linux Firewalls and Routers";
    homepage = http://www.digitage.co.uk/digitage/software/linux-security/cutter;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.offline ];
  };
}
