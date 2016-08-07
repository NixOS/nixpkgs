{ stdenv, fetchurl, perl, autoconf, makeWrapper }:

stdenv.mkDerivation rec {
  name = "automake-1.10.3";

  # TODO: Remove the `aclocal' wrapper when $ACLOCAL_PATH support is
  # available upstream; see
  # <http://debbugs.gnu.org/cgi/bugreport.cgi?bug=9026>.
  builder = ./builder.sh;

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.gz";
    sha256 = "fda9b22ec8705780c8292510b3376bb45977f45a4f7eb3578c5ad126d7758028";
  };

  buildInputs = [perl autoconf makeWrapper];

  # Disable indented log output from Make, otherwise "make.test" will
  # fail.
  preCheck = "unset NIX_INDENT_MAKE";

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  # Run the test suite in parallel.
  enableParallelBuilding = true;

  meta = {
    branch = "1.10";
    homepage = http://www.gnu.org/software/automake/;
    description = "GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
