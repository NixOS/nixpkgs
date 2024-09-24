{ lib, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "direvent";
  version = "5.4";

  src = fetchurl {
    url = "mirror://gnu/direvent/direvent-${version}.tar.gz";
    sha256 = "sha256-HbvGGSqrZ+NFclFIYD1XDGooKDgMlkIVdir5FSTXlbo=";
  };

  meta = with lib; {
    description = "Directory event monitoring daemon";
    mainProgram = "direvent";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
