{ stdenv, fetchFromGitHub, ncurses, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.9.1";
  baseName = "wavemon";
  name = "${baseName}-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libnl ];

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "109ycwnjjqc2vpnd8b86njfifczlxglnyv4rh2qmbn2i5nw2wryg";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Ncurses-based monitoring application for wireless network devices";
    homepage = https://github.com/uoaerg/wavemon;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin fpletz ];
    platforms = stdenv.lib.platforms.linux;
  };
}
