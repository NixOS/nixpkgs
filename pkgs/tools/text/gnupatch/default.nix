{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "patch-2.6.1";

  src = fetchurl {
    url = "mirror://gnu/patch/${name}.tar.gz";
    sha256 = "1fc1jyq80nswkf492fiqdbl2bhvlw2wb44ghqlfd3zngx4qkfmni";
  };

  # Fails on armv5tel-linux at least, maybe on more platforms
  # Some tests require 'ed', additionally.
  doCheck = false;

  meta = {
    description = "GNU Patch, a program to apply differences to files";

    longDescription =
      '' GNU Patch takes a patch file containing a difference listing
         produced by the diff program and applies those differences to one or
         more original files, producing patched versions.
      '';

    homepage = http://savannah.gnu.org/projects/patch;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}

# XXX: These Darwin hacks were useful with 2.5.4; assuming they're no
#  longer useful.
#
#  patches = if stdenv.isDarwin then [./setmode.patch] else [];
#} // (if stdenv.isDarwin then { ac_cv_exeext = "" ; } else {} ) )
