{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, pcre
, tinyxml
, libusb1
, libzip
, glib
, gobject-introspection
, gst_all_1
, libwebcam
}:

stdenv.mkDerivation rec {
  pname = "tiscamera";
  version = "0.9.1";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "TheImagingSource";
    repo = pname;
    rev = "v-${name}";
    sha256 = "143yp6bpzj3rqfnrcnlrcwggay37fg6rkphh4w9y9v7v4wllzf87";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
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
  ];


  cmakeFlags = [
    "-DBUILD_ARAVIS=OFF" # For GigE support. Won't need it as our camera is usb.
    "-DBUILD_GST_1_0=ON"
    "-DBUILD_TOOLS=ON"
    "-DBUILD_V4L2=ON"
    "-DBUILD_LIBUSB=ON"
  ];


  patches = [
    ./allow-pipeline-stop-in-trigger-mode.patch # To be removed next release.
  ];

  postPatch = ''
    substituteInPlace ./data/udev/80-theimagingsource-cameras.rules \
      --replace "/usr/bin/uvcdynctrl" "${libwebcam}/bin/uvcdynctrl" \
      --replace "/path/to/tiscamera/uvc-extensions" "$out/share/uvcdynctrl/data/199e"

    substituteInPlace ./src/BackendLoader.cpp \
      --replace '"libtcam-v4l2.so"' "\"$out/lib/tcam-0/libtcam-v4l2.so\"" \
      --replace '"libtcam-aravis.so"' "\"$out/lib/tcam-0/libtcam-aravis.so\"" \
      --replace '"libtcam-libusb.so"' "\"$out/lib/tcam-0/libtcam-libusb.so\""
  '';

  preConfigure = ''
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DCMAKE_INSTALL_PREFIX=$out"
      "-DTCAM_INSTALL_UDEV=$out/lib/udev/rules.d"
      "-DTCAM_INSTALL_UVCDYNCTRL=$out/share/uvcdynctrl/data/199e"
      "-DTCAM_INSTALL_GST_1_0=$out/lib/gstreamer-1.0"
      "-DTCAM_INSTALL_GIR=$out/share/gir-1.0"
      "-DTCAM_INSTALL_TYPELIB=$out/lib/girepository-1.0"
      "-DTCAM_INSTALL_SYSTEMD=$out/etc/systemd/system"
    )
  '';


  # There are gobject introspection commands launched as part of the build. Those have a runtime
  # dependency on `libtcam` (which itself is built as part of this build). In order to allow
  # that, we set the dynamic linker's path to point on the build time location of the library.
  preBuild = ''
    export LD_LIBRARY_PATH=$PWD/src:$LD_LIBRARY_PATH
  '';

  meta = with lib; {
    description = "The Linux sources and UVC firmwares for The Imaging Source cameras";
    homepage = https://github.com/TheImagingSource/tiscamera;
    license = with licenses; [ asl20 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ jraygauthier ];
  };
}