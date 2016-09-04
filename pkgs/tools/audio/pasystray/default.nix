{stdenv, fetchFromGitHub, autoconf, automake, makeWrapper, pkgconfig
, gnome3, avahi, gtk3, libnotify, libpulseaudio, xlibsWrapper}:

stdenv.mkDerivation rec {
  name = "pasystray-0.5.2";

  src = fetchFromGitHub {
    owner = "christophgysin";
    repo = "pasystray";
    rev = "6709fc1e9f792baf4f7b4507a887d5876b2cfa70";
    sha256 = "1z21wassdiwfnlcrkpdqh8ylblpd1xxjxcmib5mwix9va2lykdfv";
  };

  buildInputs = [ autoconf automake makeWrapper pkgconfig 
                  gnome3.defaultIconTheme
                  avahi gtk3 libnotify libpulseaudio xlibsWrapper ];

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
    homepage = "https://github.com/christophgysin/pasystray";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.exlevan ];
    platforms = platforms.linux;
  };
}
