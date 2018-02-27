{ stdenv, fetchurl, perl, autoconf, makeWrapper, doCheck ? false }:

stdenv.mkDerivation rec {
  name = "automake-1.16";

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.xz";
    sha256 = "12jvcmkcmd5p14b41w9f7ixd3sca97pymd6lqbkwnl8qn6bjv3zr";
  };

  nativeBuildInputs = [ autoconf perl ];
  buildInputs = [ autoconf ];

  setupHook = ./setup-hook.sh;

  # Disable indented log output from Make, otherwise "make.test" will
  # fail.
  preCheck = "unset NIX_INDENT_MAKE";
  inherit doCheck;

  # The test suite can run in parallel.
  enableParallelBuilding = true;

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = {
    branch = "1.15";
    homepage = http://www.gnu.org/software/automake/;
    description = "GNU standard-compliant makefile generator";
    license = stdenv.lib.licenses.gpl2Plus;

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    platforms = stdenv.lib.platforms.all;
  };
}
