{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, runtimeShell
, pcre
, tinyxml
, libusb1
, libzip
, zstd
, glib
, gobject-introspection
, gst_all_1
, libwebcam
, libunwind
, elfutils
, orc
, python3Packages
, libuuid
, wrapGAppsHook
, catch2
, withGui ? true
, libsForQt5
}:

with lib;

stdenv.mkDerivation rec {
  pname = "tiscamera";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "TheImagingSource";
    repo = pname;
    rev = "v-${pname}-${version}";
    sha256 = "0hpy9yhc4mn6w8gvzwif703smmcys0j2jqbz2xfghqxcyb0ykplj";
  };

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
    python3Packages.wrapPython
    wrapGAppsHook
  ] ++ optionals withGui [
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    pcre
    tinyxml
    libusb1
    libzip
    zstd
    glib
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    libwebcam
    libunwind
    elfutils
    orc
    libuuid
    python3Packages.python
  ] ++ optionals withGui [
    python3Packages.pyqt5
    libsForQt5.qtbase
  ];

  pythonPath = [
    python3Packages.pygobject3
  ] ++ optionals withGui [
    python3Packages.pyqt5
  ];

  propagatedBuildInputs = pythonPath;

  patches = [
    ./0001-Remove-wrong-volatile-usage-with-g_once_init_enter.patch
  ];

  cmakeFlags = [
    "-DBUILD_ARAVIS=OFF" # For GigE support. Won't need it as our camera is usb.
    "-DBUILD_GST_1_0=ON"
    "-DBUILD_TOOLS=ON"
    "-DBUILD_V4L2=ON"
    "-DBUILD_LIBUSB=ON"
    "-DBUILD_TESTS=ON"
    "-DTCAM_BUILD_WITH_GUI=${if withGui then "ON" else "OFF"}"
    "-DTCAM_INSTALL_UDEV=${placeholder "out"}/lib/udev/rules.d"
    "-DTCAM_INSTALL_UVCDYNCTRL=${placeholder "out"}/share/uvcdynctrl/data/199e"
    "-DTCAM_INSTALL_GST_1_0=${placeholder "out"}/lib/gstreamer-1.0"
    "-DTCAM_INSTALL_GIR=${placeholder "out"}/share/gir-1.0"
    "-DTCAM_INSTALL_TYPELIB=${placeholder "out"}/lib/girepository-1.0"
    "-DTCAM_INSTALL_SYSTEMD=${placeholder "out"}/etc/systemd/system"
    "-DTCAM_INSTALL_PYTHON3_MODULES=${placeholder "out"}/lib/${python3Packages.python.libPrefix}/site-packages"
    "-DGSTREAMER_1.0_INCLUDEDIR=${placeholder "out"}/include/gstreamer-1.0"
    # There are gobject introspection commands launched as part of the build. Those have a runtime
    # dependency on `libtcam` (which itself is built as part of this build). In order to allow
    # that, we set the dynamic linker's path to point on the build time location of the library.
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ];

  doCheck = true;

  # gstreamer tests requires, besides gst-plugins-bad, plugins installed by this expression.
  checkPhase = "ctest --force-new-ctest-process -E gstreamer";

  # wrapGAppsHook: make sure we add ourselves to the introspection
  # and gstreamer paths.
  GI_TYPELIB_PATH = "${placeholder "out"}/lib/girepository-1.0";
  GST_PLUGIN_SYSTEM_PATH_1_0 = "${placeholder "out"}/lib/gstreamer-1.0";

  QT_PLUGIN_PATH = optionalString withGui "${libsForQt5.qtbase.bin}/${libsForQt5.qtbase.qtPluginPrefix}";

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  postFixup = ''
    wrapPythonPrograms "$out $pythonPath"
  '';

  meta = {
    description = "The Linux sources and UVC firmwares for The Imaging Source cameras";
    homepage = "https://github.com/TheImagingSource/tiscamera";
    license = with licenses; [ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
