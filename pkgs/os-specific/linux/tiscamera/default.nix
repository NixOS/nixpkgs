{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, pcre
, tinyxml
, libusb1
, libzip
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
}:

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
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.wrapPython
    wrapGAppsHook
  ];

  buildInputs = [
    pcre
    tinyxml
    libusb1
    libzip
    glib
    gobject-introspection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libwebcam
    libunwind
    elfutils
    orc
    libuuid
    python3Packages.python
    python3Packages.pyqt5
  ];

  pythonPath = with python3Packages; [ pyqt5 pygobject3 ];

  propagatedBuildInputs = pythonPath;

  cmakeFlags = [
    "-DBUILD_ARAVIS=OFF" # For GigE support. Won't need it as our camera is usb.
    "-DBUILD_GST_1_0=ON"
    "-DBUILD_TOOLS=ON"
    "-DBUILD_V4L2=ON"
    "-DBUILD_LIBUSB=ON"
    "-DBUILD_TESTS=ON"
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

  postFixup = ''
    wrapPythonPrograms "$out $pythonPath"
  '';

  meta = with lib; {
    description = "The Linux sources and UVC firmwares for The Imaging Source cameras";
    homepage = "https://github.com/TheImagingSource/tiscamera";
    license = with licenses; [ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
