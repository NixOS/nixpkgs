{ stdenv, fetchurl, zlib, pcre }:

stdenv.mkDerivation rec {
  name = "tintin-2.01.4";

  src = fetchurl {
    url    = "mirror://sourceforge/tintin/${name}.tar.gz";
    sha256 = "1g7bh8xs1ml0iyraps3a3dzaycci922y7fk5j0wyr4ssyjzsy8nx";
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
