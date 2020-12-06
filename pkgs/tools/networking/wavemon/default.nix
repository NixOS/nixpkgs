{ stdenv, fetchFromGitHub, ncurses, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.9.2";
  baseName = "wavemon";
  name = "${baseName}-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libnl ];

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "0y984wm03lzqf7bk06a07mw7d1fzjsp9x7zxcvlx4xqmv7wlgb29";
  };

  meta = with stdenv.lib; {
    inherit version;
    description = "Ncurses-based monitoring application for wireless network devices";
    homepage = "https://github.com/uoaerg/wavemon";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin fpletz ];
    platforms = stdenv.lib.platforms.linux;
  };
}
