{stdenv, fetchurl, perl, autoconf, makeWrapper, doCheck ? false}:

stdenv.mkDerivation rec {
  name = "automake-1.10.3";

  builder = ./builder.sh;

  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.bz2";
    sha256 = "1p0sgv8zl6ah6vwpqf7jkrjr3cw8ydpmnbi0ljb1dhrrp0xv92p9";
  };

  buildInputs = [perl autoconf makeWrapper];

  inherit doCheck;

  # Disable indented log output from Make, otherwise "make.test" will
  # fail.
  preCheck = "unset NIX_INDENT_MAKE";

  # Don't fixup "#! /bin/sh" in Libtool, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

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
