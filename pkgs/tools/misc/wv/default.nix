{ stdenv, fetchurl, zlib, imagemagick, libpng, glib, pkgconfig, libgsf
, libxml2, bzip2 }:

stdenv.mkDerivation {
  name = "wv-1.2.4";

  src = fetchurl {
    url = mirror://sourceforge/wvware/wv-1.2.4.tar.gz;
    sha256 = "1mn2ax6qjy3pvixlnvbkn6ymy6y4l2wxrr4brjaczm121s8hjcb7";
  };

  buildInputs = [ zlib imagemagick libpng glib pkgconfig libgsf libxml2 bzip2 ];

  meta = {
    description = "Converter from Microsoft Word formats to human-editable ones";
  };
}
