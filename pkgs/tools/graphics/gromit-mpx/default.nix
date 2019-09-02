{ stdenv, fetchFromGitHub, cmake, pkgconfig
, gtk, glib, pcre, libappindicator, libpthreadstubs, libXdmcp
, libxkbcommon, epoxy, at-spi2-core, dbus, libdbusmenu
}:

stdenv.mkDerivation rec {
  name = "gromit-mpx-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "bk138";
    repo = "gromit-mpx";
    rev = "${version}";
    sha256 = "1dkmp5rhzp56sz9cfxill2pkdz2anwb8kkxkypvk2xhqi64cvkrs";
  };

  nativeBuildInputs = [ pkgconfig ];
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

    homepage = https://github.com/bk138/gromit-mpx;
    maintainers = with maintainers; [ pjones ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
