{
  lib,
  stdenv,
  fetchurl,
  m4,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "libtool";
  version = "1.5.26";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "029ggq5kri1gjn6nfqmgw4w920gyfzscjjxbsxxidal5zqsawd8w";
  };

  nativeBuildInputs = [ m4 ];
  buildInputs = [ perl ];

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;
  dontFixLibtool = true;

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

    homepage = "https://www.gnu.org/software/libtool/";

    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;

    mainProgram = "libtool";
  };
}
