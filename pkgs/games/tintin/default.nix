{ stdenv, fetchurl, zlib, pcre }:

stdenv.mkDerivation rec {
  name = "tintin-2.01.1";

  src = fetchurl {
    url    = "mirror://sourceforge/tintin/${name}.tar.gz";
    sha256 = "195wrfcys8yy953gdrl1gxryhjnx9lg1vqgxm3dyzm8bi18aa2yc";
  };

  buildInputs = [ zlib pcre ];

  preConfigure = ''
    cd src
  '';

  meta = with stdenv.lib; {
    description = "A free MUD client for macOS, Linux and Windows";
    homepage    = http://tintin.sourceforge.net;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
