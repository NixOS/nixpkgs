{ stdenv, fetchurl, pkgconfig, gtk2, libhangul }:

stdenv.mkDerivation {
  name = "nabi-1.0.0";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/nabi/nabi-1.0.0.tar.gz";
    sha256 = "0craa24pw7b70sh253arv9bg9sy4q3mhsjwfss3bnv5nf0xwnncw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk2 libhangul ];

  meta = with stdenv.lib; {
    description = "The Easy Hangul XIM";
    homepage = "https://github.com/choehwanjin/nabi";
    license = licenses.gpl2;
    maintainers = [ maintainers.ianwookim ];
    platforms = platforms.linux;
  };
}
