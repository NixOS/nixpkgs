{ stdenv, lib, fetchurl, callPackage, substituteAll, python3, pkgconfig, writeText
, xorg, gtk3, glib, pango, cairo, gdk-pixbuf, atk
, wrapGAppsHook, xorgserver, getopt, xauth, utillinux, which
, ffmpeg, x264, libvpx, libwebp, x265
, libfakeXinerama
, gst_all_1, pulseaudio, gobject-introspection
, pam }:

with lib;

let
  inherit (python3.pkgs) cython buildPythonApplication;

  xf86videodummy = xorg.xf86videodummy.overrideDerivation (p: {
    patches = [
      ./0002-Constant-DPI.patch
      ./0003-fix-pointer-limits.patch
      ./0005-support-for-30-bit-depth-in-dummy-driver.patch
    ];
  });

  xorgModulePaths = writeText "module-paths" ''
    Section "Files"
      ModulePath "${xorgserver}/lib/xorg/modules"
      ModulePath "${xorgserver}/lib/xorg/modules/extensions"
      ModulePath "${xorgserver}/lib/xorg/modules/drivers"
      ModulePath "${xf86videodummy}/lib/xorg/modules/drivers"
    EndSection
  '';

in buildPythonApplication rec {
  pname = "xpra";
  version = "4.0.2";

  src = fetchurl {
    url = "https://xpra.org/src/${pname}-${version}.tar.xz";
    sha256 = "1cs39jzi59hkl421xmhi549ndmdfzkg0ap45f4nlsn9zr9zwmp3x";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit (xorg) xkeyboardconfig;
      inherit libfakeXinerama;
    })
    ./fix-41106.patch
  ];

  postPatch = ''
    substituteInPlace setup.py --replace '/usr/include/security' '${pam}/include/security'
  '';

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = with xorg; [
    libX11 xorgproto libXrender libXi
    libXtst libXfixes libXcomposite libXdamage
    libXrandr libxkbfile
    ] ++ [
    cython

    pango cairo gdk-pixbuf atk.out gtk3 glib

    ffmpeg libvpx x264 libwebp x265

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    pam
    gobject-introspection
  ];
  propagatedBuildInputs = with python3.pkgs; [
    pillow rencode pycrypto cryptography pycups lz4 dbus-python
    netifaces numpy pygobject3 pycairo gst-python pam
    pyopengl paramiko opencv4 python-uinput pyxdg
    ipaddress idna
  ];

    # error: 'import_cairo' defined but not used
  NIX_CFLAGS_COMPILE = "-Wno-error=unused-function";

  setupPyBuildFlags = [
    "--with-Xdummy"
    "--without-strict"
    "--with-gtk3"
    # Override these, setup.py checks for headers in /usr/* paths
    "--with-pam"
    "--with-vsock"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --set XPRA_INSTALL_PREFIX "$out"
      --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux pulseaudio ]}
    )
  '';

  # append module paths to xorg.conf
  postInstall = ''
    cat ${xorgModulePaths} >> $out/etc/xpra/xorg.conf
  '';

  doCheck = false;

  enableParallelBuilding = true;

  passthru = { inherit xf86videodummy; };

  meta = {
    homepage = "http://xpra.org/";
    downloadPage = "https://xpra.org/src/";
    downloadURLRegexp = "xpra-.*[.]tar[.]xz$";
    description = "Persistent remote applications for X";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ tstrobel offline numinit ];
  };
}
