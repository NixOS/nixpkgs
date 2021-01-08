{ stdenv, fetchFromGitHub, autoreconfHook
, gtk2, hicolor-icon-theme, intltool, pkgconfig, libappindicator-gtk2
, which, wrapGAppsHook, xdotool }:

stdenv.mkDerivation rec {
  pname = "parcellite";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rickyrockrat";
    repo = "parcellite";
    rev = version;
    sha256 = "19q4x6x984s6gxk1wpzaxawgvly5vnihivrhmja2kcxhzqrnfhiy";
  };

  configureFlags = [ "--enable-appindicator=yes" ];
  nativeBuildInputs = [ autoreconfHook intltool pkgconfig wrapGAppsHook ];
  buildInputs = [ gtk2 hicolor-icon-theme libappindicator-gtk2 ];
  NIX_LDFLAGS = "-lgio-2.0";

  preFixup = ''
    # Need which and xdotool on path to fix auto-pasting.
    gappsWrapperArgs+=(--prefix PATH : "${which}/bin:${xdotool}/bin")
  '';

  meta = with stdenv.lib; {
    description = "Lightweight GTK clipboard manager";
    homepage = "https://github.com/rickyrockrat/parcellite";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
