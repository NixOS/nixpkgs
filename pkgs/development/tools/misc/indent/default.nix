{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "indent-2.2.10";

  src = fetchurl {
    url = "mirror://gnu/indent/${name}.tar.gz";
    sha256 = "0f9655vqdvfwbxvs1gpa7py8k1z71aqh8hp73f65vazwbfz436wa";
  };

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's|#include <malloc.h>|#include <malloc/malloc.h>|' ./man/texinfo2man.c
  '';

  hardeningDisable = [ "format" ];

  meta = {
    homepage = https://www.gnu.org/software/indent/;
    description = "A source code reformatter";
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
