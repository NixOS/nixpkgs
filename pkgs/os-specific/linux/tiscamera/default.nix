{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, runtimeShell
, catch2
, elfutils
, libselinux
, libsepol
, libunwind
, libusb1
, libuuid
, libzip
, orc
, pcre
, zstd
, glib
, gobject-introspection
, gst_all_1
, wrapGAppsHook
, withDoc ? true
, sphinx
, graphviz
, withAravis ? true
, aravis
, meson
, withAravisUsbVision ? withAravis
, withGui ? true
, qt5
}:

stdenv.mkDerivation rec {
  pname = "tiscamera";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "TheImagingSource";
    repo = pname;
    rev = "v-${pname}-${version}";
    sha256 = "0msz33wvqrji11kszdswcvljqnjflmjpk0aqzmsv6i855y8xn6cd";
  };

  patches = [
    ./0001-tcamconvert-tcamsrc-add-missing-include-lib-dirs.patch
    ./0001-udev-rules-fix-install-location.patch
    ./0001-cmake-find-aravis-fix-pkg-cfg-include-dirs.patch
  ];

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp external/catch/catch.hpp

    substituteInPlace ./data/udev/80-theimagingsource-cameras.rules.in \
      --replace "/bin/sh" "${runtimeShell}/bin/sh" \
      --replace "typically /usr/bin/" "" \
      --replace "typically /usr/share/theimagingsource/tiscamera/uvc-extension/" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ] ++ lib.optionals withDoc [
    sphinx
    graphviz
  ] ++ lib.optionals withAravis [
    meson
  ] ++ lib.optionals withGui [
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    elfutils
    libselinux
    libsepol
    libunwind
    libusb1
    libuuid
    libzip
    orc
    pcre
    zstd
    glib
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
  ] ++ lib.optionals withAravis [
    aravis
  ] ++ lib.optionals withGui [
    qt5.qtbase
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DTCAM_BUILD_GST_1_0=ON"
    "-DTCAM_BUILD_TOOLS=ON"
    "-DTCAM_BUILD_V4L2=ON"
    "-DTCAM_BUILD_LIBUSB=ON"
    "-DTCAM_BUILD_TESTS=ON"
    "-DTCAM_BUILD_ARAVIS=${if withAravis then "ON" else "OFF"}"
    "-DTCAM_BUILD_DOCUMENTATION=${if withDoc then "ON" else "OFF"}"
    "-DTCAM_BUILD_WITH_GUI=${if withGui then "ON" else "OFF"}"
    "-DTCAM_DOWNLOAD_MESON=OFF"
    "-DTCAM_INTERNAL_ARAVIS=OFF"
    "-DTCAM_ARAVIS_USB_VISION=${if withAravis && withAravisUsbVision then "ON" else "OFF"}"
    "-DTCAM_INSTALL_FORCE_PREFIX=ON"
  ];

  doCheck = true;

  # gstreamer tests requires, besides gst-plugins-bad, plugins installed by this expression.
  checkPhase = "ctest --force-new-ctest-process -E gstreamer";

  # wrapGAppsHook: make sure we add ourselves to the introspection
  # and gstreamer paths.
  GI_TYPELIB_PATH = "${placeholder "out"}/lib/girepository-1.0";
  GST_PLUGIN_SYSTEM_PATH_1_0 = "${placeholder "out"}/lib/gstreamer-1.0";

  QT_PLUGIN_PATH = lib.optionalString withGui "${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}";

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "The Linux sources and UVC firmwares for The Imaging Source cameras";
    homepage = "https://github.com/TheImagingSource/tiscamera";
    license = with licenses; [ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
