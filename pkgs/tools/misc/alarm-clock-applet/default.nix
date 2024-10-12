{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapGAppsHook3
, gst_all_1
, libnotify
, libayatana-appindicator
}:

stdenv.mkDerivation rec {
  pname = "alarm-clock-applet";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "alarm-clock";
    rev = version;
    hash = "sha256-10hkWWEsAUJnGeu35bR5d0RFKd9CKDZI7WGMzmEM3rI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/alarm-clock-applet/alarm-clock/commit/6a11003099660dfae0e3d5800f49880d3a26f5ec.patch";
      hash = "sha256-NP1PlEw5AFWZgywvppIs2e+5EfMSPbU4Pq2tIfwODrQ=";
    })
    (fetchpatch {
      url = "https://github.com/alarm-clock-applet/alarm-clock/commit/cbcf22fac5b45ab251ade2e7e993f422f33f926e.patch";
      hash = "sha256-xKaaNfXsv9Ckwy73r1n93kOWIZ01fU5GDqYSQCch1Kc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libnotify
    libayatana-appindicator
  ];

  cmakeFlags = [
    # gconf is already deprecated
    "-DENABLE_GCONF_MIGRATION=OFF"
  ];

  meta = with lib; {
    description = "Fully-featured alarm clock with an indicator";
    homepage = "https://alarm-clock-applet.github.io";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
    mainProgram = "alarm-clock-applet";
  };
}
