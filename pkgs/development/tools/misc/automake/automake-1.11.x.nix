{stdenv, fetchurl, perl, autoconf, makeWrapper, doCheck ? false}:

stdenv.mkDerivation rec {
  name = "automake-1.11";

  builder = ./builder.sh;
  
  setupHook = ./setup-hook.sh;

  src = fetchurl {
    url = "mirror://gnu/automake/${name}.tar.bz2";
    sha256 = "1h5a821z4i3dbgqg67igvbxcwn487kkkkx83q0m00n9mw9xz5ai9";
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
  };
}
