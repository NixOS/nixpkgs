{ stdenv, fetchurl }:

let
  version = "5.6.1";
in
stdenv.mkDerivation {
  name = "numdiff-${version}";
  src = fetchurl {
    url = "http://ftp.igh.cnrs.fr/pub/nongnu/numdiff/numdiff-${version}.tar.gz";
    sha256 = "062byxp9vajj4flg1rqh0r2nwg9yx608mbsj5y25wkrzmkgcq3fx";
  };
  meta = {
    description = ''
      A little program that can be used to compare putatively similar files
      line by line and field by field, ignoring small numeric differences
      or/and different numeric formats.
    '';
    homepage = "http://www.nongnu.org/numdiff/";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = stdenv.lib.maintainers.bbenoist;
    platforms = stdenv.lib.platforms.gnu;
  };
}
