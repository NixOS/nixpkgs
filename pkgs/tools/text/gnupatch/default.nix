{ stdenv, fetchurl
, ed
, buildPlatform, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "patch-2.7.6";

  src = fetchurl {
    url = "mirror://gnu/patch/${name}.tar.xz";
    sha256 = "1zfqy4rdcy279vwn2z1kbv19dcfw25d2aqy9nzvdkq5bjzd0nqdc";
  };

  buildInputs = stdenv.lib.optional doCheck ed;

  configureFlags = stdenv.lib.optionals (hostPlatform != buildPlatform) [
    "ac_cv_func_strnlen_working=yes"
  ];

  doCheck = hostPlatform.libc != "musl"; # not cross;

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
