{ stdenv, fetchurl, ed }:

stdenv.mkDerivation rec {
  name = "patch-2.7.3";

  src = fetchurl {
    url = "mirror://gnu/patch/${name}.tar.bz2";
    sha256 = "0za8wh4lgjk8k9s0rd7y5gjid99126myrh3nkifpi4ny6rkj9xh2";
  };

  buildInputs = stdenv.lib.optional doCheck ed;

  crossAttrs = {
    configureFlags = [ "ac_cv_func_strnlen_working=yes" ];
  };

  patches = [ ./bashishms.patch ];

  doCheck = true;

  meta = {
    description = "GNU Patch, a program to apply differences to files";

    longDescription =
      '' GNU Patch takes a patch file containing a difference listing
         produced by the diff program and applies those differences to one or
         more original files, producing patched versions.
      '';

    homepage = http://savannah.gnu.org/projects/patch;

    license = stdenv.lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
