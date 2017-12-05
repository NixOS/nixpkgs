{ stdenv, fetchFromGitHub, autoreconfHook
, gtk2, hicolor_icon_theme, intltool, pkgconfig, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "parcellite-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rickyrockrat";
    repo = "parcellite";
    rev = version;
    sha256 = "19q4x6x984s6gxk1wpzaxawgvly5vnihivrhmja2kcxhzqrnfhiy";
  };

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk2 hicolor_icon_theme ];

  meta = with stdenv.lib; {
    description = "Lightweight GTK+ clipboard manager";
    homepage = https://github.com/rickyrockrat/parcellite;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
