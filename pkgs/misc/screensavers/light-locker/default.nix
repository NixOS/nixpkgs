{ stdenv
, fetchFromGitHub
, which
, xfce
, glib
, pkgconfig
, libX11
, gtk3
, dbus_glib
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "${basename}-${version}";
  basename = "light-locker";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "the-cavalry";
    repo = basename;
    rev = "v${version}";
    sha256 = "0ygkp5vgkx2nfhfql6j2jsfay394gda23ir3sx4f72j4agsirjvj";
  };

  buildInputs = [ which xfce.xfce4_dev_tools glib pkgconfig libX11 gtk3 dbus_glib systemd wrapGAppsHook ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/the-cavalry/light-locker;
    description = "Light-locker is a simple locker";
    longDescription = ''
      light-locker is a simple locker (forked from gnome-screensaver) that aims to have simple, sane, secure defaults and be well integrated with the desktop while not carrying any desktop-specific dependencies.
      It relies on lightdm for locking and unlocking your session via ConsoleKit/UPower or logind/systemd.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ obadz ];
    platforms = platforms.linux;
  };
}
