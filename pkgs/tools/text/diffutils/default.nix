{ stdenv, fetchurl, xz, coreutils ? null }:

stdenv.mkDerivation rec {
  name = "diffutils-3.6";

  src = fetchurl {
    url = "mirror://gnu/diffutils/${name}.tar.xz";
    sha256 = "1mivg0fy3a6fcn535ln8nkgfj6vxh5hsxxs5h6692wxmsjyyh8fn";
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
