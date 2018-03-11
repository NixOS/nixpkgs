{ stdenv
, fetchFromGitHub
, which
, xfce
, glib
, pkgconfig
, libX11
, libXScrnSaver
, libXxf86misc
, gtk3
, dbus-glib
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

  # Patch so that systemd is "found" when configuring.
  patches = [ ./systemd.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ which xfce.xfce4_dev_tools glib systemd
                  libX11 libXScrnSaver libXxf86misc gtk3 dbus-glib wrapGAppsHook ];

  preConfigure = ''
    ./autogen.sh
  '';

  configureFlags = [ "--with-xf86gamma-ext" "--with-mit-ext"
                     "--with-dpms-ext" "--with-systemd"
                     # ConsoleKit and UPower were dropped in favor
                     # of systemd replacements
                     "--without-console-kit" "--without-upower" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/the-cavalry/light-locker;
    description = "A simple session-locker for LightDM";
    longDescription = ''
      A simple locker (forked from gnome-screensaver) that aims to
      have simple, sane, secure defaults and be well integrated with
      the desktop while not carrying any desktop-specific
      dependencies.

      It relies on LightDM for locking and unlocking your session via
      ConsoleKit/UPower or logind/systemd.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ obadz ];
    platforms = platforms.linux;
  };
}
