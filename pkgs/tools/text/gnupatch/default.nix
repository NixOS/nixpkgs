{ stdenv, fetchurl, ed }:

stdenv.mkDerivation rec {
  name = "patch-2.6.1";

  src =
    if stdenv.isDarwin
    then fetchurl {
      # Temporary fix for
      # http://lists.gnu.org/archive/html/bug-patch/2010-01/msg00004.html .
      url = "ftp://alpha.gnu.org/gnu/patch/patch-2.6.1.87-94d8.tar.gz";
      sha256 = "0jnw8p0nvkmwi1a2z56bssqik8fvkb71zd2cpzl1sklnrg1g3b6p";
    } else fetchurl {
      url = "mirror://gnu/patch/${name}.tar.gz";
      sha256 = "1fc1jyq80nswkf492fiqdbl2bhvlw2wb44ghqlfd3zngx4qkfmni";
    };

  buildInputs = (stdenv.lib.optional doCheck ed);

  crossAttrs = {
    configureFlags = [ "ac_cv_func_strnlen_working=yes" ];
  };

  doCheck = true;

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
