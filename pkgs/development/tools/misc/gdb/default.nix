{ fetchurl, stdenv, ncurses, readline, gmp, mpfr, expat, texinfo, zlib
, dejagnu, perl, pkgconfig
, python ? null
, guile ? null
, target ? null
# Support all known targets in one gdb binary.
, multitarget ? false
# Additional dependencies for GNU/Hurd.
, mig ? null, hurd ? null

}:

let

  basename = "gdb-7.11";

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
    url = "mirror://gnu/gdb/${basename}.tar.xz";
    sha256 = "1hg5kwwdvi9b9nxzxfjnx8fx3gip75fqyvkp82xpf3b3rcb42hvs";
  };

  nativeBuildInputs = [ pkgconfig texinfo perl ]
    ++ stdenv.lib.optional isGNU mig;

  buildInputs = [ ncurses readline gmp mpfr expat zlib python guile ]
    ++ stdenv.lib.optional isGNU hurd
    ++ stdenv.lib.optional doCheck dejagnu;

  enableParallelBuilding = true;

  configureFlags = with stdenv.lib;
    [ "--with-gmp=${gmp}" "--with-mpfr=${mpfr}" "--with-system-readline"
      "--with-system-zlib" "--with-expat" "--with-libexpat-prefix=${expat}"
      "--with-separate-debug-dir=/run/current-system/sw/lib/debug"
    ]
    ++ optional (target != null) "--target=${target.config}"
    ++ optional multitarget "--enable-targets=all"
    ++ optional (elem stdenv.system platforms.cygwin) "--without-python";

  crossAttrs = {
    # Do not add --with-python here to avoid cross building it.
    configureFlags = with stdenv.lib;
      [ "--with-gmp=${gmp.crossDrv}" "--with-mpfr=${mpfr.crossDrv}" "--with-system-readline"
        "--with-system-zlib" "--with-expat" "--with-libexpat-prefix=${expat.crossDrv}" "--without-python"
      ]
      ++ optional (target != null) "--target=${target.config}"
      ++ optional multitarget "--enable-targets=all";
  };

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/bfd.info
    '';

  # TODO: Investigate & fix the test failures.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "The GNU Project debugger";

    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';

    homepage = http://www.gnu.org/software/gdb/;

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = with platforms; linux ++ cygwin ++ darwin;
    maintainers = with maintainers; [ pierron ];
  };
}
