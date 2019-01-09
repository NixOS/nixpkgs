{ stdenv, fetchFromGitHub, autoconf, automake, makeWrapper, pkgconfig
, gnome3, avahi, gtk3, libappindicator-gtk3, libnotify, libpulseaudio
, xlibsWrapper
}:

stdenv.mkDerivation rec {
  name = "pasystray-${version}";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "christophgysin";
    repo = "pasystray";
    rev = name;
    sha256 = "0xx1bm9kimgq11a359ikabdndqg5q54pn1d1dyyjnrj0s41168fk";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    autoconf automake makeWrapper
    gnome3.defaultIconTheme
    avahi gtk3 libappindicator-gtk3 libnotify libpulseaudio xlibsWrapper
  ];

  preConfigure = ''
    aclocal
    autoconf
    autoheader
    automake --add-missing
  '';

  preFixup = ''
    wrapProgram "$out/bin/pasystray" \
      --prefix XDG_DATA_DIRS : "${gnome3.defaultIconTheme}/share:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "PulseAudio system tray";
    homepage = https://github.com/christophgysin/pasystray;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ exlevan kamilchm ];
    platforms = platforms.linux;
  };
}
