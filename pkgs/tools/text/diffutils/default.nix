{ stdenv, fetchurl, coreutils ? null }:

stdenv.mkDerivation rec {
  name = "diffutils-3.3";

  src = fetchurl {
    url = "mirror://gnu/diffutils/${name}.tar.xz";
    sha256 = "1761vymxbp4wb5rzjvabhdkskk95pghnn67464byvzb5mfl8jpm2";
  };

  /* If no explicit coreutils is given, use the one from stdenv. */
  nativeBuildInputs = [ coreutils ];

  meta = {
    homepage = http://www.gnu.org/software/diffutils/diffutils.html;
    description = "Commands for showing the differences between files (diff, cmp, etc.)";
  };
}
