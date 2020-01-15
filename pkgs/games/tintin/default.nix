{ stdenv, fetchurl, zlib, pcre }:

stdenv.mkDerivation rec {
  name = "tintin-2.01.8";

  src = fetchurl {
    url    = "mirror://sourceforge/tintin/${name}.tar.gz";
    sha256 = "056g82yi784mf4gbrida9fxqmz347m2l9vad2ksv2fhl7g553y2s";
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
