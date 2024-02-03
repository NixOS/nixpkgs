{ lib, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "direvent";
  version = "5.3";

  src = fetchurl {
    url = "mirror://gnu/direvent/direvent-${version}.tar.gz";
    sha256 = "sha256-lAWop32kn+krvkrxi/kl/5H20zdMELfXAKAxusuUxJc=";
  };

  meta = with lib; {
    description = "Directory event monitoring daemon";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
