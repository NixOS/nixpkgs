{ fetchurl, fetchgit, stdenv, ncurses, readline, gmp, mpfr, expat, texinfo
, dejagnu, python, target ? null

# Set it to true to fetch the latest release/branchpoint from git.
, bleedingEdgeVersion ? false

# Additional dependencies for GNU/Hurd.
, mig ? null, hurd ? null

# needed for the git version
, flex, bison }:

let
  basename =
    if bleedingEdgeVersion
    then "gdb-7.3.20110726"
    else "gdb-7.4";

  # Whether (cross-)building for GNU/Hurd.  This is an approximation since
  # having `stdenv ? cross' doesn't tell us if we're building `hostDrv' and
  # `buildDrv'.
  isGNU =
      stdenv.system == "i686-gnu"
      || (stdenv ? cross && stdenv.cross.config == "i586-pc-gnu");
in

assert isGNU -> mig != null && hurd != null;

stdenv.mkDerivation rec {
  name = basename + stdenv.lib.optionalString (target != null)
      ("-" + target.config);

  src =
    if bleedingEdgeVersion
    then fetchgit {
        url = "git://sourceware.org/git/gdb.git";
        rev = "refs/tags/gdb_7_3-2011-07-26-release";
      }
    else fetchurl {
        url = "mirror://gnu/gdb/${basename}.tar.bz2";
        # md5 is provided by the annoucement page
        # http://www.gnu.org/s/gdb/download/ANNOUNCEMENT
        md5 = "95a9a8305fed4d30a30a6dc28ff9d060";
      };

  # I think python is not a native input, but I leave it
  # here while I will not need it cross building
  buildNativeInputs = [ texinfo python ]
    ++ stdenv.lib.optional isGNU mig
    ++ stdenv.lib.optionals bleedingEdgeVersion [ flex bison ];

  buildInputs = [ ncurses readline gmp mpfr expat ]
    ++ stdenv.lib.optional isGNU hurd
    ++ stdenv.lib.optional doCheck dejagnu;

  configureFlags = with stdenv.lib;
    '' --with-gmp=${gmp} --with-mpfr=${mpfr} --with-system-readline
       --with-expat --with-libexpat-prefix=${expat}
    ''
    + optionalString (target != null) " --target=${target.config}"
    + optionalString (elem stdenv.system platforms.cygwin) "  --without-python"
  ;

  crossAttrs = {
    # Do not add --with-python here to avoid cross building it.
    configureFlags =
      '' --with-gmp=${gmp.hostDrv} --with-mpfr=${mpfr.hostDrv} --with-system-readline
         --with-expat --with-libexpat-prefix=${expat.hostDrv} --without-python
      '' + stdenv.lib.optionalString (target != null)
         " --target=${target.config}";
  };

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/{standards,configure,bfd}.info
    '';

  enableParallelBuilding = true;

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

    platforms = with platforms; linux ++ cygwin;
    maintainers = with maintainers; [ ludo pierron ];
  };
}
