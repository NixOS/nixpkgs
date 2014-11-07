{stdenv, fetchurl, unzip, autoconf, automake, pkgconfig, gnome_icon_theme, avahi, gtk3, libnotify, pulseaudio, x11}:

stdenv.mkDerivation rec {
  name = "pasystray-0.4.0";

  src = fetchurl {
    url = "https://github.com/christophgysin/pasystray/archive/${name}.zip";
    sha256 = "1gpb7yqcxqglv50iqbkg2lg3r0z07jm4ir2zqmvns6sgddks590w";
  };

  buildInputs = [ unzip autoconf automake pkgconfig gnome_icon_theme avahi gtk3 libnotify pulseaudio x11 ];

  preConfigure = ''
    aclocal
    autoconf
    autoheader
    automake --add-missing
  '';

  meta = with stdenv.lib; {
    description = "PulseAudio system tray";
    homepage = "https://github.com/christophgysin/pasystray";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.exlevan ];
    platfoms = platforms.linux;
  };
}
