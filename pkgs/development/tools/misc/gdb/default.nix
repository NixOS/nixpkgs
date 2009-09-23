{ fetchurl, stdenv, ncurses, readline, gmp, mpfr, texinfo }:

stdenv.mkDerivation rec {
  name = "gdb-6.8";

  src = fetchurl {
    url = "mirror://gnu/gdb/${name}.tar.bz2";
    sha256 = "067qpnpgmz9jffi208q5c981xsyn8naq3rkp5ypg477lddcgvpzf";
  };

  buildInputs = [ ncurses readline gmp mpfr texinfo ];

  configureFlags = "--with-gmp=${gmp} --with-mpfr=${mpfr} --with-system-readline";

  postInstall = ''
    # Remove Info files already provided by Binutils and other packages.
    rm $out/info/{standards,configure,bfd}.info
  '';

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
