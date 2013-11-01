{ stdenv, fetchurl, perl, autoconf, makeWrapper }:

stdenv.mkDerivation rec {
  name = "automake-1.11.6";

  # TODO: Remove the `aclocal' wrapper when $ACLOCAL_PATH support is
  # available upstream; see
  # <http://debbugs.gnu.org/cgi/bugreport.cgi?bug=9026>.
  builder = ./builder.sh;

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.xz";
    sha256 = "1ffbc6cc41f0ea6c864fbe9485b981679dc5e350f6c4bc6c3512f5a4226936b5";
  };

  patches = [ ./fix-test-autoconf-2.69.patch ];

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
    homepage = http://www.gnu.org/software/automake/;
    description = "GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
