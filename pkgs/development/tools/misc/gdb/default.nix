{ fetchurl, stdenv, ncurses, readline, gmp, mpfr, expat, texinfo
, dejagnu, python, target ? null

# Additional dependencies for GNU/Hurd.
, mig ? null, hurd ? null

}:

let

  basename = "gdb-7.7";

  # Whether (cross-)building for GNU/Hurd.  This is an approximation since
  # having `stdenv ? cross' doesn't tell us if we're building `crossDrv' and
  # `nativeDrv'.
  isGNU =
      stdenv.system == "i686-gnu"
      || (stdenv ? cross && stdenv.cross.config == "i586-pc-gnu");

in

assert isGNU -> mig != null && hurd != null;

stdenv.mkDerivation rec {
  name = basename + stdenv.lib.optionalString (target != null)
      ("-" + target.config);

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}.tar.bz2";
    sha256 = "08vcb97j1b7vxwq6088wb6s3g3bm8iwikd922y0xsgbbxv3d2104";
  };

  patches = [ ./edit-signals.patch ];

  # I think python is not a native input, but I leave it
  # here while I will not need it cross building
  nativeBuildInputs = [ texinfo python ]
    ++ stdenv.lib.optional isGNU mig;

  buildInputs = [ ncurses readline gmp mpfr expat ]
    ++ stdenv.lib.optional isGNU hurd
    ++ stdenv.lib.optional doCheck dejagnu;

  enableParallelBuilding = true;

  configureFlags = with stdenv.lib;
    '' --with-gmp=${gmp} --with-mpfr=${mpfr} --with-system-readline
       --with-expat --with-libexpat-prefix=${expat}
    ''
    + optionalString (target != null) " --target=${target.config}"
    + optionalString (elem stdenv.system platforms.cygwin) "  --without-python";

  crossAttrs = {
    # Do not add --with-python here to avoid cross building it.
    configureFlags =
      '' --with-gmp=${gmp.crossDrv} --with-mpfr=${mpfr.crossDrv} --with-system-readline
         --with-expat --with-libexpat-prefix=${expat.crossDrv} --without-python
      '' + stdenv.lib.optionalString (target != null)
         " --target=${target.config}";
  };

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/{standards,configure,bfd}.info
    '';

  # TODO: Investigate & fix the test failures.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "GDB, the GNU Project debugger";

    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';

    homepage = http://www.gnu.org/software/gdb/;

    license = "GPLv3+";

    platforms = with platforms; linux ++ cygwin ++ darwin;
    maintainers = with maintainers; [ pierron ];
  };
}
