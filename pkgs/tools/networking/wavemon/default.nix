{ stdenv, fetchFromGitHub, ncurses, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.9.0";
  baseName = "wavemon";
  name = "${baseName}-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libnl ];

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "07cid0h3mcyr74nnrzzf8k5n1p9a4y3wij43jbiaqmkpxilcc1i6";
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
