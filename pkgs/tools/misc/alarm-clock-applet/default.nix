{ stdenv, fetchurl, pkgconfig
, glib
, gtk2
, gst_all_1
, gnome
, libnotify
, libxml2
, libunique
, intltool
}:

stdenv.mkDerivation rec {
  version = "0.3.4";
  name = "alarm-clock-applet-${version}";

  src = fetchurl {
    url = "http://launchpad.net/alarm-clock/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1mrrw5cgv0izdmhdg83vprvbj6062yzk77b2nr1nx6hhmk00946r";
  };

  buildInputs = [
    pkgconfig
    glib
    gtk2
    gst_all_1.gstreamer
    gnome.GConf
    gnome.gnome_icon_theme
    libnotify
    libxml2
    libunique
    intltool
  ];

  meta = with stdenv.lib; {
    homepage = http://alarm-clock.pseudoberries.com/;
    description = "A fully-featured alarm clock for your GNOME panel or equivalent";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
