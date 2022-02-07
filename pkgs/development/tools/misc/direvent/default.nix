{ lib, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "direvent";
  version = "5.2";

  src = fetchurl {
    url = "mirror://gnu/direvent/direvent-${version}.tar.gz";
    sha256 = "0m9vi01b1km0cpknflyzsjnknbava0s1n6393b2bpjwyvb6j5613";
  };

  meta = with lib; {
    description = "Directory event monitoring daemon";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
