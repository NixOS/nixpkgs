{ stdenv, fetchurl, buildPythonApplication, pythonPackages
, python, cython, pkgconfig
, xorg, gtk, glib, pango, cairo, gdk_pixbuf, atk, pycairo
, makeWrapper, xkbcomp, xorgserver, getopt, xauth, utillinux, which, fontsConf, xkeyboard_config
, ffmpeg, x264, libvpx, libwebp
, libfakeXinerama }:

buildPythonApplication rec {
  name = "xpra-0.16.2";
  namePrefix = "";
  src = fetchurl {
    url = "http://xpra.org/src/${name}.tar.xz";
    sha256 = "0h55rv46byzv2g8g77bm0a0py8jpz3gbr5fhr5jy9sisyr0vk6ff";
  };

  buildInputs = [
    cython pkgconfig

    xorg.libX11 xorg.renderproto xorg.libXrender xorg.libXi xorg.inputproto xorg.kbproto
    xorg.randrproto xorg.damageproto xorg.compositeproto xorg.xextproto xorg.recordproto
    xorg.xproto xorg.fixesproto xorg.libXtst xorg.libXfixes xorg.libXcomposite xorg.libXdamage
    xorg.libXrandr xorg.libxkbfile

    pango cairo gdk_pixbuf atk gtk glib

    ffmpeg libvpx x264 libwebp

    makeWrapper
  ];

  propagatedBuildInputs = with pythonPackages; [
    pillow pygtk pygobject
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
      --set XKB_BINDIR "${xkbcomp}/bin" \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib \
      --prefix PATH : ${getopt}/bin:${xorgserver}/bin:${xauth}/bin:${which}/bin:${utillinux}/bin
  '';

  preCheck = "exit 0";

  #TODO: replace postInstall with postFixup to avoid double wrapping of xpra; needs more work though
  #postFixup = ''
  #  sed -i '2iexport XKB_BINDIR="${xkbcomp}/bin"' $out/bin/xpra
  #  sed -i '3iexport FONTCONFIG_FILE="${fontsConf}"' $out/bin/xpra
  #  sed -i '4iexport PATH=${getopt}/bin:${xorgserver}/bin:${xauth}/bin:${which}/bin:${utillinux}/bin\${PATH:+:}\$PATH' $out/bin/xpra
  #'';


  meta = {
    homepage = http://xpra.org/;
    description = "Persistent remote applications for X";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
