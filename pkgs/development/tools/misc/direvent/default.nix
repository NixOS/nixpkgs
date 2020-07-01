{ stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  name = "direvent-${version}";
  version = "5.2";

  src = fetchurl {
    url = "mirror://gnu/direvent/${name}.tar.gz";
    sha256 = "0m9vi01b1km0cpknflyzsjnknbava0s1n6393b2bpjwyvb6j5613";
  };

  meta = with stdenv.lib; {
    description = "Directory event monitoring daemon";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
