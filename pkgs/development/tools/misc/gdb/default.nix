{ fetchurl, stdenv, ncurses, readline, gmp, mpfr, expat, texinfo
, target ? null }:

let
    basename = "gdb-7.0";
in
stdenv.mkDerivation rec {
  name = basename + stdenv.lib.optionalString (target != null)
      ("-" + target.config);

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}.tar.bz2";
    sha256 = "1k9y271gnnvi0fny8ycydcd79snigwh88rgwi03ad782r2awcl67";
  };

  # TODO: Add optional support for Python scripting.
  buildInputs = [ ncurses readline gmp mpfr expat texinfo ];

  configureFlags =
    '' --with-gmp=${gmp} --with-mpfr=${mpfr} --with-system-readline
       --with-expat --with-libexpat-prefix=${expat}
    '' + stdenv.lib.optionalString (target != null)
       " --target=${target.config}";

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/{standards,configure,bfd}.info
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
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
