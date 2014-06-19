{ stdenv, fetchurl, libiconvOrNull, recode }:

stdenv.mkDerivation rec {
  name = "enca-1.15";

  src = fetchurl {
    url = "http://dl.cihar.com/enca/${name}.tar.bz2";
    sha256 = "1iibfl2s420x7bc1hvxr1ys4cpz579brg2m2ln4rp677azmrr8mv";
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
