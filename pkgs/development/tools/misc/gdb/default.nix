{ fetchurl, stdenv, ncurses, readline, gmp, mpfr, texinfo }:

stdenv.mkDerivation rec {
  name = "gdb-7.0";

  src = fetchurl {
    url = "mirror://gnu/gdb/${name}.tar.bz2";
    sha256 = "1k9y271gnnvi0fny8ycydcd79snigwh88rgwi03ad782r2awcl67";
  };

  buildInputs = [ ncurses readline gmp mpfr texinfo ];

  configureFlags = "--with-gmp=${gmp} --with-mpfr=${mpfr} --with-system-readline";

  meta = {
    description = "GDB, the GNU Project debugger";

    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';

    homepage = http://www.gnu.org/software/gdb/;

    license = "GPLv3+";

    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.cygwin;
  };
}
