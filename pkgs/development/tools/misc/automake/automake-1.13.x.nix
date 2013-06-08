{ stdenv, fetchurl, perl, autoconf, makeWrapper, doCheck ? false }:

stdenv.mkDerivation rec {
  name = "automake-1.13.1";

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.xz";
    sha256 = "12yi1bzkipi7qdmkdy77pazljsa9z7q66hi6c4rq73p7hbv6rkbf";
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
    homepage = "http://www.gnu.org/software/automake/";
    description = "GNU Automake, a GNU standard-compliant makefile generator";
    license = "GPLv2+";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
  };
}
