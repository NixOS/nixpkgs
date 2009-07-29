{ stdenv, fetchurl, m4, perl }:

stdenv.mkDerivation rec {
  name = "autoconf-2.64";

  src = fetchurl {
    url = "mirror://gnu/autoconf/${name}.tar.bz2";
    sha256 = "11damk9x09616cjdfxx9y73igd96zzylgq0l4j57qzify6nlqbw7";
  };

  patches = [ ./test-suite-fix.patch ];

  buildInputs = [ m4 perl ];

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

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
