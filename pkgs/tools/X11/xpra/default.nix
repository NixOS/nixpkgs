{ stdenv, lib, fetchurl, callPackage, substituteAll, python3, pkgconfig
, xorg, gtk3, glib, pango, cairo, gdk_pixbuf, atk
, wrapGAppsHook, xorgserver, getopt, xauth, utillinux, which
, ffmpeg, x264, libvpx, libwebp
, libfakeXinerama
, gst_all_1, pulseaudio, gobject-introspection
, pam }:

with lib;

let
  inherit (python3.pkgs) cython buildPythonApplication;

  xf86videodummy = callPackage ./xf86videodummy { };
in buildPythonApplication rec {
  pname = "xpra";
  version = "2.3.4";

  src = fetchurl {
    url = "https://xpra.org/src/${pname}-${version}.tar.xz";
    sha256 = "0wa3kx54himy3i1b2801hlzfilh3cf4kjk40k1cjl0ds28m5hija";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit (xorg) xkeyboardconfig;
    })
  ];

  nativeBuildInputs = [ pkgconfig gobject-introspection wrapGAppsHook ];
  buildInputs = with xorg; [
    libX11 xorgproto libXrender libXi
    libXtst libXfixes libXcomposite libXdamage
    libXrandr libxkbfile
    ] ++ [
    cython

    pango cairo gdk_pixbuf atk gtk3 glib

    ffmpeg libvpx x264 libwebp

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    pam
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pillow rencode pycrypto cryptography pycups lz4 dbus-python
    netifaces numpy websockify pygobject3 pycairo gst-python pam
  ];

  NIX_CFLAGS_COMPILE = [
    # error: 'import_cairo' defined but not used
    "-Wno-error=unused-function"
  ];

  setupPyBuildFlags = [
    "--with-Xdummy"
    "--without-strict"
    "--with-gtk3"
    "--without-gtk2"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --set XPRA_INSTALL_PREFIX "$out"
      --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux pulseaudio ]}
    )
  '';

  doCheck = false;

  passthru = { inherit xf86videodummy; };

  meta = {
    homepage = http://xpra.org/;
    downloadPage = "https://xpra.org/src/";
    downloadURLRegexp = "xpra-.*[.]tar[.]xz$";
    description = "Persistent remote applications for X";
    platforms = platforms.linux;
    license = licenses.gpl2;
    # https://github.com/NixOS/nixpkgs/pull/48872#issuecomment-433559636
    broken = true;
    maintainers = with maintainers; [ tstrobel offline numinit ];
  };
}
