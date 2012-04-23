{ stdenv, fetchurl, ed }:

stdenv.mkDerivation (rec {
  name = "patch-2.6.1";

  src = fetchurl {
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

//

(stdenv.lib.optionalAttrs stdenv.isDarwin {
  patches = [ ./darwin-fix.patch ];
}))
