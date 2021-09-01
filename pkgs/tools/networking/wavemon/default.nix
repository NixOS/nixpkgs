{ lib, stdenv, fetchFromGitHub, ncurses, libnl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "wavemon";
  version = "0.9.3";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses libnl ];

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "0m9n5asjxs1ir5rqprigqcrm976mgjvh4yql1jhfnbszwbf95193";
  };

  meta = with lib; {
    description = "Ncurses-based monitoring application for wireless network devices";
    homepage = "https://github.com/uoaerg/wavemon";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin fpletz ];
    platforms = lib.platforms.linux;
  };
}
