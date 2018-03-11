{ stdenv, fetchFromGitHub, ncurses, libnl, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.8.2";
  baseName = "wavemon";
  name = "${baseName}-${version}";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ ncurses libnl ];

  src = fetchFromGitHub {
    owner = "uoaerg";
    repo = "wavemon";
    rev = "v${version}";
    sha256 = "0rqpp7rhl9rlwnihsapaiy62v33h45fm3d0ia2nhdjw7fwkwcqvs";
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
