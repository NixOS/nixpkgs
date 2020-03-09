{ stdenv, fetchurl, pkgconfig, intltool, openssl, curl, libnotify,
  libappindicator-gtk3, gst_all_1, gtk3, dconf, wrapGAppsHook, aria2 ? null
}:

stdenv.mkDerivation rec {
  pname = "uget";
  version = "2.2.2";

  src = fetchurl {
    url = "mirror://sourceforge/urlget/${pname}-${version}.tar.gz";
    sha256 = "1hmzk907blgzc1z6wv4zbzqrwad06zfm1rqc3svh5garxw8z7xsw";
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
    gtk3
    (stdenv.lib.getLib dconf)
  ]
  ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good ])
  ++ (stdenv.lib.optional (aria2 != null) aria2);

  enableParallelBuilding = true;

  preFixup = stdenv.lib.optionalString (aria2 != null)
               ''gappsWrapperArgs+=(--suffix PATH : "${aria2}/bin")'';

  meta = with stdenv.lib; {
    description = "Download manager using GTK and libcurl";
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
