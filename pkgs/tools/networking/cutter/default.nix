{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cutter-1.03";

  src = fetchurl {
    url = "http://www.digitage.co.uk/digitage/files/cutter/${name}.tgz";
    sha256 = "05cn22wi70l9ybhmzw0sy3fd6xxz0lq49fws4zxzm2i0qb3zmx2d";
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
