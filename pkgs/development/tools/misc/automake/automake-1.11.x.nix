{stdenv, fetchurl, perl, autoconf, makeWrapper, doCheck ? true}:

stdenv.mkDerivation rec {
  name = "automake-1.11.1";

  # TODO: Remove the `aclocal' wrapper when $ACLOCAL_PATH support is
  # available upstream; see
  # <http://debbugs.gnu.org/cgi/bugreport.cgi?bug=9026>.
  builder = ./builder.sh;

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.bz2";
    sha256 = "1bn7jl11wbkyy4ivgja92zkyjj8w3agwp2xnf7g8f7qa1qy9s5av";
  };

  buildInputs = [perl autoconf makeWrapper];

  inherit doCheck;

  # Disable indented log output from Make, otherwise "make.test" will
  # fail.
  preCheck = "unset NIX_INDENT_MAKE";

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  patches = [ ./more-robust-silent-tests.patch ];

  meta = {
    homepage = http://www.gnu.org/software/automake/;
    description = "GNU Automake, a GNU standard-compliant makefile generator";

    longDescription = ''
      GNU Automake is a tool for automatically generating
      `Makefile.in' files compliant with the GNU Coding
      Standards.  Automake requires the use of Autoconf.
    '';

    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
