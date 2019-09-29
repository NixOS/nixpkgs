{ stdenv, fetchurl, zlib, pcre }:

stdenv.mkDerivation rec {
  name = "tintin-2.01.90";

  src = fetchurl {
    url    = "mirror://sourceforge/tintin/${name}.tar.gz";
    sha256 = "0v4khry5fmsp5w370v00ici5c8ryxak4mkaz9h4xfl1jk4mfygkb";
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
