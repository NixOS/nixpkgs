{ stdenv, fetchFromGitHub, autoconf, automake, makeWrapper, pkgconfig
, gnome3, avahi, gtk3, libappindicator-gtk3, libnotify, libpulseaudio
, xlibsWrapper
}:

stdenv.mkDerivation rec {
  name = "pasystray-${version}";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "christophgysin";
    repo = "pasystray";
    rev = name;
    sha256 = "0cc9hjyw4gr4ip4lw74pzb1l9sxs3ffhf0xn0m1fhmyfbjyixwkh";
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
