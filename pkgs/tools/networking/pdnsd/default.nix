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

  configureFlags = [ "--enable-ipv6" ];

  # fix ipv6 on darwin
  CPPFLAGS = "-D__APPLE_USE_RFC_3542";

  meta = with stdenv.lib; {
    description = "Permanent DNS caching";
    homepage = http://members.home.nl/p.a.rombouts/pdnsd;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [viric];
  };
}
