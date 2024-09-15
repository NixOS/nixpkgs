{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, gtk, glib, pcre, libappindicator, libpthreadstubs, xorg
, libxkbcommon, libepoxy, at-spi2-core, dbus, libdbusmenu
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "gromit-mpx";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "gromit-mpx";
    rev = version;
    sha256 = "sha256-olDQGw0qDWwXpqRopVoEPDXLRpFiiBo+/jiVeL7R6QA=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook3 ];
  buildInputs = [
    gtk glib pcre libappindicator libpthreadstubs
    xorg.libXdmcp libxkbcommon libepoxy at-spi2-core
    dbus libdbusmenu
  ];

  meta = with lib; {
    description = "Desktop annotation tool";

    longDescription = ''
      Gromit-MPX (GRaphics Over MIscellaneous Things) is a small tool
      to make annotations on the screen.
    '';

    homepage = "https://github.com/bk138/gromit-mpx";
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    mainProgram = "gromit-mpx";
  };
}
