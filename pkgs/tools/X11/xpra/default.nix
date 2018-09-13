{ stdenv, lib, fetchurl, python2Packages, pkgconfig
, xorg, gtk2, glib, pango, cairo, gdk_pixbuf, atk
, makeWrapper, xorgserver, getopt, xauth, utillinux, which
, ffmpeg, x264, libvpx, libwebp
, libfakeXinerama
, gst_all_1, pulseaudio, gobjectIntrospection
, pam }:

with lib;

let
  inherit (python2Packages) cython buildPythonApplication;
in buildPythonApplication rec {
  name = "xpra-${version}";
  version = "2.3.3";

  src = fetchurl {
    url = "https://xpra.org/src/${name}.tar.xz";
    sha256 = "1azvvddjfq7lb5kmbn0ilgq2nf7pmymsc3b9lhbjld6w156qdv01";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cython

    xorg.libX11 xorg.renderproto xorg.libXrender xorg.libXi xorg.inputproto xorg.kbproto
    xorg.randrproto xorg.damageproto xorg.compositeproto xorg.xextproto xorg.recordproto
    xorg.xproto xorg.fixesproto xorg.libXtst xorg.libXfixes xorg.libXcomposite xorg.libXdamage
    xorg.libXrandr xorg.libxkbfile

    pango cairo gdk_pixbuf atk gtk2 glib

    ffmpeg libvpx x264 libwebp

    gobjectIntrospection
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav

    pam

    makeWrapper
  ];

  propagatedBuildInputs = with python2Packages; [
    pillow pygtk pygobject2 rencode pycrypto cryptography pycups lz4 dbus-python
    netifaces numpy websockify pygobject3 gst-python pam
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0) $(pkg-config --cflags xtst)"
    substituteInPlace xpra/server/auth/pam_auth.py --replace "/lib/libpam.so.1" "${pam}/lib/libpam.so"
    substituteInPlace xpra/x11/bindings/keyboard_bindings.pyx --replace "/usr/share/X11/xkb" "${xorg.xkeyboardconfig}/share/X11/xkb"
  '';
  setupPyBuildFlags = ["--with-Xdummy" "--without-strict"];

  postInstall = ''
    wrapProgram $out/bin/xpra \
      --set XPRA_INSTALL_PREFIX "$out" \
      --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
      --set GST_PLUGIN_SYSTEM_PATH_1_0 "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib  \
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux pulseaudio ]}
  '';

  preCheck = "exit 0";

  #TODO: replace postInstall with postFixup to avoid double wrapping of xpra; needs more work though
  #postFixup = ''
  #  sed -i '3iexport FONTCONFIG_FILE="${fontsConf}"' $out/bin/xpra
  #  sed -i '4iexport PATH=${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux ]}\${PATH:+:}\$PATH' $out/bin/xpra
  #'';


  meta = {
    homepage = http://xpra.org/;
    downloadPage = "https://xpra.org/src/";
    downloadURLRegexp = "xpra-.*[.]tar[.]xz$";
    description = "Persistent remote applications for X";
    platforms = platforms.linux;
    maintainers = with maintainers; [ tstrobel offline ];
    license = licenses.gpl2;
  };
}
