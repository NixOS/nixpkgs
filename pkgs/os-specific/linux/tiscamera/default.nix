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
, python3
, libuuid
}:

stdenv.mkDerivation rec {
  pname = "tiscamera";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "TheImagingSource";
    repo = pname;
    rev = "v-${pname}-${version}";
    sha256 = "07vp6khgl6qd3a4519dmx1s5bfw7pld793p50pjn29fqh91fm93g";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
    python3
    libuuid
  ];

  cmakeFlags = [
    "-DBUILD_ARAVIS=OFF" # For GigE support. Won't need it as our camera is usb.
    "-DBUILD_GST_1_0=ON"
    "-DBUILD_TOOLS=ON"
    "-DBUILD_V4L2=ON"
    "-DBUILD_LIBUSB=ON"
    "-DTCAM_INSTALL_UDEV=${placeholder "out"}/lib/udev/rules.d"
    "-DTCAM_INSTALL_UVCDYNCTRL=${placeholder "out"}/share/uvcdynctrl/data/199e"
    "-DTCAM_INSTALL_GST_1_0=${placeholder "out"}/lib/gstreamer-1.0"
    "-DTCAM_INSTALL_GIR=${placeholder "out"}/share/gir-1.0"
    "-DTCAM_INSTALL_TYPELIB=${placeholder "out"}/lib/girepository-1.0"
    "-DTCAM_INSTALL_SYSTEMD=${placeholder "out"}/etc/systemd/system"
    # There are gobject introspection commands launched as part of the build. Those have a runtime
    # dependency on `libtcam` (which itself is built as part of this build). In order to allow
    # that, we set the dynamic linker's path to point on the build time location of the library.
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
  ];

  postPatch = ''
    substituteInPlace ./src/BackendLoader.cpp \
      --replace '"libtcam-v4l2.so"' "\"$out/lib/tcam-0/libtcam-v4l2.so\"" \
      --replace '"libtcam-aravis.so"' "\"$out/lib/tcam-0/libtcam-aravis.so\"" \
      --replace '"libtcam-libusb.so"' "\"$out/lib/tcam-0/libtcam-libusb.so\""
  '';

  meta = with lib; {
    description = "The Linux sources and UVC firmwares for The Imaging Source cameras";
    homepage = "https://github.com/TheImagingSource/tiscamera";
    license = with licenses; [ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
