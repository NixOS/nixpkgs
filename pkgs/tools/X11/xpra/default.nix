{ stdenv, lib, fetchurl, pythonPackages, pkgconfig
, xorg, gtk2, glib, pango, cairo, gdk_pixbuf, atk
, makeWrapper, xkbcomp, xorgserver, getopt, xauth, utillinux, which, fontsConf, xkeyboard_config
, ffmpeg, x264, libvpx, libwebp
, libfakeXinerama
, gst_all_1, pulseaudioLight, gobjectIntrospection }:

with lib;

let
  inherit (pythonPackages) python cython buildPythonApplication;
in buildPythonApplication rec {
  name = "xpra-0.17.6";
  namePrefix = "";
  src = fetchurl {
    url = "http://xpra.org/src/${name}.tar.xz";
    sha256 = "1z7v58m45g10icpv22qg4dipafcfsdqkxqz73z3rwsb6r0kdyrpj";
  };

  buildInputs = [
    cython pkgconfig

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

    makeWrapper
  ];

  propagatedBuildInputs = with pythonPackages; [
    pillow pygtk pygobject2 rencode pycrypto cryptography pycups lz4 dbus-python
    netifaces numpy websockify pygobject3 gst-python
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0) $(pkg-config --cflags xtst)"
  '';
  setupPyBuildFlags = ["--with-Xdummy" "--without-strict"];

  preInstall = ''
    # see https://bitbucket.org/pypa/setuptools/issue/130/install_data-doesnt-respect-prefix
    ${python}/bin/${python.executable} setup.py install_data --install-dir=$out --root=$out
    sed -i '/ = data_files/d' setup.py
  '';

  postInstall = ''
    wrapProgram $out/bin/xpra \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --set XPRA_LOG_DIR "\$HOME/.xpra" \
      --set XPRA_INSTALL_PREFIX "$out" \
      --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
      --set GST_PLUGIN_SYSTEM_PATH_1_0 "$GST_PLUGIN_SYSTEM_PATH_1_0" \
      --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib \
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux pulseaudioLight ]} \
  '';

  preCheck = "exit 0";

  #TODO: replace postInstall with postFixup to avoid double wrapping of xpra; needs more work though
  #postFixup = ''
  #  sed -i '3iexport FONTCONFIG_FILE="${fontsConf}"' $out/bin/xpra
  #  sed -i '4iexport PATH=${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux ]}\${PATH:+:}\$PATH' $out/bin/xpra
  #'';


  meta = {
    homepage = http://xpra.org/;
    description = "Persistent remote applications for X";
    platforms = platforms.linux;
    maintainers = with maintainers; [ tstrobel offline ];
  };
}
