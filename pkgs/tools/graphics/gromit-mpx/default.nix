{ stdenv, fetchFromGitHub, cmake, pkgconfig
, gtk, glib, pcre, libappindicator, libpthreadstubs, libXdmcp
, libxkbcommon, epoxy, at-spi2-core, dbus, libdbusmenu
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gromit-mpx";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "gromit-mpx";
    rev = version;
    sha256 = "1dvn7vwg4fg1a3lfj5f7nij1vcxm27gyf2wr817f3qb4sx5xmjwy";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [
    cmake
    gtk glib pcre libappindicator libpthreadstubs
    libXdmcp libxkbcommon epoxy at-spi2-core
    dbus libdbusmenu
  ];

  meta = with stdenv.lib; {
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
