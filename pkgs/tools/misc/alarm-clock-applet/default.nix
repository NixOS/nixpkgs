{ stdenv, fetchFromGitHub
, pkgconfig
, autoconf
, automake111x
, libtool

, glib
, gtk2
, gst_all_1
, gnome2
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

  src = fetchFromGitHub {
    owner = "joh";
    repo = "alarm-clock";
    rev = version;
    sha256 = "18blvgy8hmw3jidz7xrv9yiiilnzcj65m6wxhw58nrnbcqbpydwn";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    automake111x
    autoconf
    libtool

    gnome2.gnome-common

    wrapGAppsHook
  ];

  preConfigure = "./autogen.sh";

  buildInputs = [
    glib
    gtk2
    gst_all_1.gstreamer
    gnome2.GConf
    gnome2.gnome_icon_theme
    libnotify
    libxml2
    libunique
  ] ++ gst_plugins;

  propagatedUserEnvPkgs = [ gnome2.GConf.out ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://alarm-clock.pseudoberries.com/;
    description = "A fully-featured alarm clock for your GNOME panel or equivalent";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
