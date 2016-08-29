{ stdenv, fetchurl, xz, coreutils ? null }:

stdenv.mkDerivation rec {
  name = "diffutils-3.5";

  src = fetchurl {
    url = "mirror://gnu/diffutils/${name}.tar.xz";
    sha256 = "0csmqfz8ks23kdjsq0v2ll1acqiz8lva06dj19mwmymrsp69ilys";
  };

  outputs = [ "out" "info" ];

  /* If no explicit coreutils is given, use the one from stdenv. */
  nativeBuildInputs = [ xz.bin coreutils ];

  meta = {
    homepage = http://www.gnu.org/software/diffutils/diffutils.html;
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
    platforms = stdenv.lib.platforms.unix;
  };
}
