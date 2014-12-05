{ stdenv, fetchurl, libiconvOrNull, recode }:

stdenv.mkDerivation rec {
  name = "enca-1.16";

  src = fetchurl {
    url = "http://dl.cihar.com/enca/${name}.tar.xz";
    sha256 = "0hg7ggldam66l9j53nlrvi2lv1k99r2qfk6dh23vg6mi05cph7bw";
  };

  buildInputs = [ recode libiconvOrNull ];

  meta = {
    homepage = http://freecode.com/projects/enca;
    description = "Detects the encoding of text files and reencodes them";

    longDescription = ''
        Enca detects the encoding of text files, on the basis of knowledge
        of their language. It can also convert them to other encodings,
        allowing you to recode files without knowing their current encoding.
        It supports most of Central and East European languages, and a few
        Unicode variants, independently on language.
    '';

    license = stdenv.lib.licenses.gpl2;

    platforms = stdenv.lib.platforms.all;
  };
}
