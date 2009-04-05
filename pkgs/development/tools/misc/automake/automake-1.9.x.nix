{stdenv, fetchurl, perl, autoconf, makeWrapper}:

stdenv.mkDerivation {
  name = "automake-1.9.6";
  
  builder = ./builder.sh;
  
  setupHook = ./setup-hook.sh;
  
  src = fetchurl {
    url = ftp://ftp.gnu.org/gnu/automake/automake-1.9.6.tar.gz;
    md5 = "c60f77a42f103606981d456f1615f5b4";
  };
  
  buildInputs = [perl autoconf makeWrapper];

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
