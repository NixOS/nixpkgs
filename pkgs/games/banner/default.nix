{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "banner";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "pronovic";
    repo = "banner";
    rev = "BANNER_V${version}";
    sha256 = "ISSnGzrFSzSj/+KxgeFtaw4H+4Ea5x5S5C8xjcjKWqQ=";
  };

  meta = with lib; {
    homepage = "https://github.com/pronovic/banner";
    description = "Print large banners to ASCII terminals";
    license = licenses.gpl2Only;

    longDescription = ''
      An implementation of the traditional Unix-program used to display
      large characters.
    '';

    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
  };
}
