{ lib, stdenv, fetchFromGitHub, fetchpatch
, pkg-config
, autoconf
, automake111x
, libtool

, glib
, gtk2
, gst_all_1
, gnome2
, gnome-icon-theme
, libnotify
, libxml2
, libunique
, intltool
, gst_plugins ? with gst_all_1; [ gst-plugins-base gst-plugins-good gst-plugins-ugly ]
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "0.3.4";
  pname = "alarm-clock-applet";

  src = fetchFromGitHub {
    owner = "joh";
    repo = "alarm-clock";
    rev = version;
    sha256 = "18blvgy8hmw3jidz7xrv9yiiilnzcj65m6wxhw58nrnbcqbpydwn";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/joh/alarm-clock/pull/209
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/joh/alarm-clock/commit/969e7ba8225610cce55b14fcb599bc6f7771bd9a.patch";
      sha256 = "0ajhir22b5ww9pkmzy9mlc9f2lr1q6wgvm9iqzjf4xsg4gm4jy1k";
    })
  ];

  nativeBuildInputs = [
    pkg-config
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
    gnome-icon-theme
    libnotify
    libxml2
    libunique
  ] ++ gst_plugins;

  propagatedUserEnvPkgs = [ gnome2.GConf.out ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://alarm-clock.pseudoberries.com/";
    description = "A fully-featured alarm clock for your GNOME panel or equivalent";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.rasendubi ];
  };
}
