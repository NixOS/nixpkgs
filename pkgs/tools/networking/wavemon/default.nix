{ stdenv, fetchFromGitHub, ncurses, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.8.1";
  baseName = "wavemon";
  name = "${baseName}-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libnl ];

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "0mx61rzl8a66pmigv2fh75zgdalxx75a5s1b7ydbviz18ihhjyls";
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
