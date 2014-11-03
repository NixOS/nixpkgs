{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "rhash-1.3.3";

  src = fetchurl {
    url = "mirror://sourceforge/rhash/${name}-src.tar.gz";
    sha1 = "0981bdc98ba7ef923b1a6cd7fd8bb0374cff632e";
  };

  installFlags = [ "DESTDIR=$(out)" "PREFIX=/" ];

  meta = with stdenv.lib; {
    homepage = http://rhash.anz.ru;
    description = "Console utility for computing and verifying hash sums of files";
    platforms = platforms.linux;
  };
}
