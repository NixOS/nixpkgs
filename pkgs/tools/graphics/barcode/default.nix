{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "0.99";
  pname = "barcode";
  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1indapql5fjz0bysyc88cmc54y8phqrbi7c76p71fgjp45jcyzp8";
  };

  hardeningDisable = [ "format" ];

  meta = with lib; {
    description = "GNU barcode generator";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
    downloadPage = "https://ftp.gnu.org/gnu/barcode/";
    updateWalker = true;
    homepage = "https://www.gnu.org/software/barcode/";
    license = licenses.gpl3;
  };
}
