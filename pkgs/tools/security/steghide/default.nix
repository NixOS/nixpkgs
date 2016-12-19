{ stdenv, fetchurl, libjpeg, libmcrypt, zlib, libmhash, gettext, libtool}:

stdenv.mkDerivation rec {
  buildInputs = [ libjpeg libmcrypt zlib libmhash gettext libtool ];
  version = "0.5.1";
  name = "steghide-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/steghide/steghide/${version}/steghide-${version}.tar.gz" ;
    sha256 = "78069b7cfe9d1f5348ae43f918f06f91d783c2b3ff25af021e6a312cf541b47b";
  };

  patches = [
    ./patches/steghide-0.5.1-gcc34.patch
    ./patches/steghide-0.5.1-gcc4.patch
    ./patches/steghide-0.5.1-gcc43.patch
  ];

  # AM_CXXFLAGS needed for automake
  preConfigure = ''
    export AM_CXXFLAGS="$CXXFLAGS -std=c++0x"
  '';

  meta = with stdenv.lib; {
    homepage = http://steghide.sourceforge.net/;
    description = "Steganography program that is able to hide data in various kinds of image- and audio-files";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
