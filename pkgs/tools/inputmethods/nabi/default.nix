{ stdenv, fetchurl, pkgconfig, gtk2, libhangul }:

stdenv.mkDerivation {
  name = "nabi-1.0.0";

  src = fetchurl {
    url = "http://nabi.googlecode.com/files/nabi-1.0.0.tar.gz";
    sha256 = "0craa24pw7b70sh253arv9bg9sy4q3mhsjwfss3bnv5nf0xwnncw";
  };

  buildInputs = [ gtk2 libhangul pkgconfig ];

  meta = with stdenv.lib; {
    description = "The Easy Hangul XIM";
    homepage = https://code.google.com/p/nabi;
    license = licenses.gpl2;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.linux;
  };
}
