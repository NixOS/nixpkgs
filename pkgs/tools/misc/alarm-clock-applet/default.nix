{ stdenv, fetchurl, makeWrapper, pkgconfig
, glib
, gtk2
, gst_all_1
, gnome
, libnotify
, libxml2
, libunique
, intltool
, gst_plugins ? with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-ugly ]
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "0.3.4";
  name = "alarm-clock-applet-${version}";

  src = fetchurl {
    url = "http://launchpad.net/alarm-clock/trunk/${version}/+download/${name}.tar.gz";
    sha256 = "1mrrw5cgv0izdmhdg83vprvbj6062yzk77b2nr1nx6hhmk00946r";
  };

  nativeBuildInputs = [
    makeWrapper
    pkgconfig
  ];

  buildInputs = [
    glib
    gtk2
    gst_all_1.gstreamer
    gst_plugins
    gnome.GConf
    gnome.gnome_icon_theme
    libnotify
    libxml2
    libunique
    intltool
    wrapGAppsHook
  ];

  propagatedUserEnvPkgs = [ gnome.GConf.out ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://alarm-clock.pseudoberries.com/;
    description = "A fully-featured alarm clock for your GNOME panel or equivalent";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
