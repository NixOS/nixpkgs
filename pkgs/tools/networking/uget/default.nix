{ lib, stdenv, fetchurl, pkg-config, intltool, openssl, curl, libnotify,
  libappindicator-gtk3, gst_all_1, gtk3, dconf, wrapGAppsHook3, aria2 ? null
}:

stdenv.mkDerivation rec {
  pname = "uget";
  version = "2.2.3-1";

  src = fetchurl {
    url = "mirror://sourceforge/urlget/${pname}-${version}.tar.gz";
    sha256 = "0jchvgkkphhwp2z7vd4axxr9ns8b6vqc22b2z8a906qm8916wd8i";
  };

  # Apply upstream fix for -fno-common toolchains.
  postPatch = ''
    # TODO: remove the replace once upstream fix is released:
    #   https://sourceforge.net/p/urlget/uget2/ci/14890943c52e0a5cd2a87d8a1c51cbffebee7cf9/
    substituteInPlace ui-gtk/UgtkBanner.h --replace "} banner;" "};"
  '';

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    curl
    libnotify
    libappindicator-gtk3
    gtk3
    (lib.getLib dconf)
  ]
  ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good ])
  ++ (lib.optional (aria2 != null) aria2);

  enableParallelBuilding = true;

  preFixup = lib.optionalString (aria2 != null)
               ''gappsWrapperArgs+=(--suffix PATH : "${aria2}/bin")'';

  meta = with lib; {
    description = "Download manager using GTK and libcurl";
    longDescription = ''
      uGet is a VERY Powerful download manager application with a large
      inventory of features but is still very light-weight and low on
      resources, so don't let the impressive list of features scare you into
      thinking that it "might be too powerful" because remember power is good
      and lightweight power is uGet!
    '';
    homepage = "http://www.ugetdm.com";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
    mainProgram = "uget-gtk";
  };
}
