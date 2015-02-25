{ stdenv, fetchurl, buildPythonPackage, python, cython, pkgconfig,
xorg, gtk, glib, pango, cairo, gdk_pixbuf, pygtk, atk, pygobject,
pycairo, ffmpeg, x264, libvpx, pil, libwebp, libxkbfile}:

buildPythonPackage rec {
  name = "xpra-0.14.19";
  namePrefix = "";

  src = fetchurl {
    url = "http://xpra.org/src/${name}.tar.xz";
    sha256 = "0jifaysz4br1v0zibnzgd0k02rgybbsysvwrgbar1452sjb3db5m";
  };

  buildInputs = [
    cython pkgconfig

    xorg.libX11 xorg.renderproto xorg.libXrender xorg.libXi xorg.inputproto xorg.kbproto
    xorg.randrproto xorg.damageproto xorg.compositeproto xorg.xextproto xorg.recordproto
    xorg.xproto xorg.fixesproto xorg.libXtst xorg.libXfixes xorg.libXcomposite xorg.libXdamage
    xorg.libXrandr

    pango cairo gdk_pixbuf atk gtk glib

    ffmpeg libvpx x264 libwebp libxkbfile
  ];

  propagatedBuildInputs = [
    pil pygtk pygobject
  ];

  # Even after i tried monkey patching, their tests just fail, looks like
  # they don't have automated testing out of the box? http://xpra.org/trac/ticket/177
  doCheck = false;

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0) $(pkg-config --cflags xtst)"
  '';

  preInstall = ''
    # see https://bitbucket.org/pypa/setuptools/issue/130/install_data-doesnt-respect-prefix
    ${python}/bin/${python.executable} setup.py install_data --install-dir=$out --root=$out
    sed -i '/ = data_files/d' setup.py
  '';

  meta = {
    homepage = http://xpra.org/;
    description = "Persistent remote applications for X";
    platforms = stdenv.lib.platforms.linux;
  };
}
