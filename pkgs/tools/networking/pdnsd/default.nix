{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "pdnsd-1.2.9a-par";

  src = fetchurl {
    url = http://members.home.nl/p.a.rombouts/pdnsd/releases/pdnsd-1.2.9a-par.tar.gz;
    sha256 = "0yragv5zk77a1hfkpnsh17vvsw8b14d6mzfng4bb7i58rb83an5v";
  };

  patchPhase = ''
    sed -i 's/.*(cachedir).*/:/' Makefile.in
  '';

  meta = { 
    description = "Permanent DNS caching";
    homepage = http://www.phys.uu.nl/~rombouts/pdnsd.html;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
