{ stdenv, fetchurl }:

let
  version = "5.8.1";
in
stdenv.mkDerivation {
  name = "numdiff-${version}";
  src = fetchurl {
    url = "mirror://savannah/numdiff/numdiff-${version}.tar.gz";
    sha256 = "00zm9955gjsid0daa94sbw69klk0vrnrrh0ihijza99kysnvmblr";
  };
  meta = {
    description = ''
      A little program that can be used to compare putatively similar files
      line by line and field by field, ignoring small numeric differences
      or/and different numeric formats.
    '';
    homepage = http://www.nongnu.org/numdiff/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.bbenoist ];
    platforms = stdenv.lib.platforms.gnu;
  };
}
