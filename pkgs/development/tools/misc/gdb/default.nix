{ fetchurl, fetchgit, stdenv, ncurses, readline, gmp, mpfr, expat, texinfo
, dejagnu, python, target ? null

# Set it to true to fetch the latest release/branchpoint from git.
, bleedingEdgeVersion ? false

# needed for the git version
, flex, bison }:

let
    basename =
      if bleedingEdgeVersion
      then "gdb-7.3.20110726"
      else "gdb-7.3";
in

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
        md5 = "485022b8df7ba2221f217e128f479fe7";
      };

  # I think python is not a native input, but I leave it
  # here while I will not need it cross building
  buildNativeInputs = [ texinfo python ]
  ++ stdenv.lib.optionals bleedingEdgeVersion [ flex bison ];

  buildInputs = [ ncurses readline gmp mpfr expat ]
    ++ stdenv.lib.optional doCheck dejagnu;

  configureFlags =
    '' --with-gmp=${gmp} --with-mpfr=${mpfr} --with-system-readline
       --with-expat --with-libexpat-prefix=${expat} --with-python
    '' + stdenv.lib.optionalString (target != null)
       " --target=${target.config}";

  crossAttrs = {
    # Do not add --with-python here to avoid cross building it.
    configureFlags =
      '' --with-gmp=${gmp.hostDrv} --with-mpfr=${mpfr.hostDrv} --with-system-readline
         --with-expat --with-libexpat-prefix=${expat.hostDrv}
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

    platforms = with platforms; linux ++ cygwin;
    maintainers = with maintainers; [ ludo pierron ];
  };
}
