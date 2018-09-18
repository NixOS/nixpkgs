{ stdenv, fetchurl, buildPythonApplication
, python, cython, pkgconfig
, xorg, gtk3, glib, pango, cairo, gdk_pixbuf, atk, pygobject3, pycairo, gobjectIntrospection
, makeWrapper, xorgserver, getopt, xauth, utillinux, which, fontsConf
, ffmpeg, x264, libvpx, libwebp
, libfakeXinerama, pam }:

buildPythonApplication rec {
  name = "xpra-${version}";
  version = "2.2.5";

  src = fetchurl {
    url = "https://xpra.org/src/${name}.tar.xz";
    sha256 = "1q2l00nc3bgwlhjzkbk4a8x2l8z9w1799yn31icsx5hrgh98a1js";
  };

  patchPhase = ''
    substituteInPlace setup.py --replace 'pycairo' 'py3cairo'
    substituteInPlace xpra/client/gtk3/cairo_workaround.pyx --replace 'pycairo/pycairo.h' 'py3cairo.h'
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    xorg.libX11 xorg.renderproto xorg.libXrender xorg.libXi xorg.inputproto xorg.kbproto
    xorg.randrproto xorg.damageproto xorg.compositeproto xorg.xextproto xorg.recordproto
    xorg.xproto xorg.fixesproto xorg.libXtst xorg.libXfixes xorg.libXcomposite xorg.libXdamage
    xorg.libXrandr xorg.libxkbfile

    pango cairo gdk_pixbuf atk gtk3 glib gobjectIntrospection

    ffmpeg libvpx x264 libwebp

    makeWrapper

    pam
  ];

  propagatedBuildInputs = [
    pygobject3 pycairo cython
  ];

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-3.0) $(pkg-config --cflags xtst)"
    substituteInPlace xpra/server/auth/pam_auth.py --replace "/lib/libpam.so.1" "${pam}/lib/libpam.so"
  '';
  setupPyBuildFlags = [ "--without-strict" "--with-gtk3" "--without-gtk2" "--with-Xdummy" ];

  preInstall = ''
    # see https://bitbucket.org/pypa/setuptools/issue/130/install_data-doesnt-respect-prefix
    ${python}/bin/${python.executable} setup.py install_data --install-dir=$out --root=$out
    sed -i '/ = data_files/d' setup.py
  '';

  postInstall = ''
    wrapProgram $out/bin/xpra \
      --set FONTCONFIG_FILE "${fontsConf}" \
      --prefix LD_LIBRARY_PATH : ${libfakeXinerama}/lib \
      --prefix PATH : ${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux ]}
  '';

  preCheck = "exit 0";
  doInstallCheck = false;

  #TODO: replace postInstall with postFixup to avoid double wrapping of xpra; needs more work though
  #postFixup = ''
  #  sed -i '3iexport FONTCONFIG_FILE="${fontsConf}"' $out/bin/xpra
  #  sed -i '4iexport PATH=${stdenv.lib.makeBinPath [ getopt xorgserver xauth which utillinux ]}\${PATH:+:}\$PATH' $out/bin/xpra
  #'';


  meta = with stdenv.lib; {
    homepage = http://xpra.org/;
    downloadPage = "https://xpra.org/src/";
    downloadURLRegexp = "xpra-.*[.]tar[.]xz$";
    description = "Persistent remote applications for X";
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
