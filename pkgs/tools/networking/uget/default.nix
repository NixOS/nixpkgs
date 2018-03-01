{ stdenv, fetchurl, pkgconfig, intltool, openssl, curl, libnotify,
  libappindicator-gtk3, gst_all_1, gnome3, wrapGAppsHook, aria2 ? null
}:

stdenv.mkDerivation rec {
  name = "uget-${version}";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/urlget/${name}.tar.gz";
    sha256 = "0rg2mr2cndxvnjib8zm5dp7y2hgbvnqkz2j2jmg0xlzfh9d34b2m";
  };

  nativeBuildInputs = [
    pkgconfig
    intltool
    wrapGAppsHook
  ];
  
  buildInputs = [
    openssl
    curl
    libnotify
    libappindicator-gtk3
    gnome3.gtk
    (stdenv.lib.getLib gnome3.dconf)
  ]
  ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good ])
  ++ (stdenv.lib.optional (aria2 != null) aria2);

  enableParallelBuilding = true;

  preFixup = stdenv.lib.optionalString (aria2 != null)
               ''gappsWrapperArgs+=(--suffix PATH : "${aria2}/bin")'';

  meta = with stdenv.lib; {
    description = "Download manager using gtk+ and libcurl";
    longDescription = ''
      uGet is a VERY Powerful download manager application with a large
      inventory of features but is still very light-weight and low on
      resources, so don't let the impressive list of features scare you into
      thinking that it "might be too powerful" because remember power is good
      and lightweight power is uGet!
    '';
    homepage = http://www.ugetdm.com;
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
