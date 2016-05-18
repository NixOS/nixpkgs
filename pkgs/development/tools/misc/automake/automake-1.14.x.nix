{ stdenv, fetchurl, perl, autoconf, makeWrapper, doCheck ? false }:

stdenv.mkDerivation rec {
  name = "automake-1.14.1";

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.xz";
    sha256 = "0s86rzdayj1licgj35q0mnynv5xa8f4p32m36blc5jk9id5z1d59";
  };

  buildInputs = [ perl autoconf ];

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
    branch = "1.14";
    homepage = "http://www.gnu.org/software/automake/";
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
