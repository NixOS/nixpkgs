{stdenv, fetchurl, unzip, autoconf, automake, makeWrapper, pkgconfig
, gnome3, avahi, gtk3, libnotify, pulseaudio, x11}:

stdenv.mkDerivation rec {
  name = "pasystray-0.5.2";

  src = fetchurl {
    url = "https://github.com/christophgysin/pasystray/archive/${name}.zip";
    sha256 = "084jld5zk89h4akll73bwhfav6mpg55zmdd5kvlg396rqi9lqkj4";
  };

  buildInputs = [ unzip autoconf automake makeWrapper pkgconfig 
                  gnome3.defaultIconTheme
                  avahi gtk3 libnotify pulseaudio x11 ];

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
    platfoms = platforms.linux;
  };
}
