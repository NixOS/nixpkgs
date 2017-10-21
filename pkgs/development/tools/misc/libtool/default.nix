{stdenv, fetchurl, m4, perl}:

stdenv.mkDerivation rec {
  name = "libtool-1.5.26";
  
  src = fetchurl {
    url = "mirror://gnu/libtool/${name}.tar.gz";
    sha256 = "029ggq5kri1gjn6nfqmgw4w920gyfzscjjxbsxxidal5zqsawd8w";
  };
  
  buildInputs = [m4 perl];

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = {
    description = "Generic library support script";

    longDescription = ''
      GNU libtool is a generic library support script.  Libtool hides
      the complexity of using shared libraries behind a consistent,
      portable interface.

      To use libtool, add the new generic library building commands to
      your Makefile, Makefile.in, or Makefile.am.  See the
      documentation for details.
    '';

    homepage = http://www.gnu.org/software/libtool/;

    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
