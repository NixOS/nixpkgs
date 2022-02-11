{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, gtk, glib, pcre, libappindicator, libpthreadstubs, libXdmcp
, libxkbcommon, libepoxy, at-spi2-core, dbus, libdbusmenu
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gromit-mpx";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "gromit-mpx";
    rev = version;
    sha256 = "sha256-K+NJagRdxnFw410pHDP+OY6yyFu/7mhLvZ8DIz08dsA=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook ];
  buildInputs = [
    gtk glib pcre libappindicator libpthreadstubs
    libXdmcp libxkbcommon libepoxy at-spi2-core
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
    license = licenses.gpl2;
  };
}
