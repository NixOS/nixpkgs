{stdenv, fetchurl, m4, perl, lzma}:

stdenv.mkDerivation rec {
  name = "autoconf-2.63";
  
  src = fetchurl {
    url = "mirror://gnu/autoconf/${name}.tar.lzma";
    sha256 = "1k5lyxsq6781c02b4ism4ddpzkywysiv65pxaw61r5qipz2ab196";
  };

  buildInputs = [m4 perl lzma];
  
  unpackCmd = "lzma -d < $src | tar -x ";

  doCheck = true;

  # Don't fixup "#! /bin/sh" in Autoconf, otherwise it will use the
  # "fixed" path in generated files!
  dontPatchShebangs = true;

  meta = {
    homepage = http://www.gnu.org/software/autoconf/;
    description = "GNU Autoconf, a part of the GNU Build System";

    longDescription = ''
      GNU Autoconf is an extensible package of M4 macros that produce
      shell scripts to automatically configure software source code
      packages.  These scripts can adapt the packages to many kinds of
      UNIX-like systems without manual user intervention.  Autoconf
      creates a configuration script for a package from a template
      file that lists the operating system features that the package
      can use, in the form of M4 macro calls.
    '';

    license = "GPLv2+";
  };
}
