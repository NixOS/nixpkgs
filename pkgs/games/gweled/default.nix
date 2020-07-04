{ stdenv, fetchbzr, intltool
, gtk2, wrapGAppsHook, autoreconfHook, pkgconfig
, libmikmod, librsvg, libcanberra-gtk2, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  pname = "gweled";
  version = "unstable-2018-02-15";

  src = fetchbzr {
    url = "lp:gweled";
    rev = "94";
    sha256 = "01c38y4df5a06wqbsmsn8ysxx7hav9yvw6zdwbc9m5m55z7vmdb8";
  };

  doCheck = false;

  nativeBuildInputs = [ wrapGAppsHook intltool autoreconfHook pkgconfig ];

  buildInputs = [ gtk2 libmikmod librsvg hicolor-icon-theme libcanberra-gtk2 ];

  configureFlags = [ "--disable-setgid" ];

  meta = with stdenv.lib; {
    description = "Bejeweled clone game";
    homepage = "https://gweled.org";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.genesis ];
  };
}
