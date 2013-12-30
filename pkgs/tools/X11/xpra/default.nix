{ stdenv, fetchurl, buildPythonPackage
, python, cython, pkgconfig
, xorg, gtk, glib, pango, cairo, gdk_pixbuf, pygtk, atk, pygobject, pycairo
, ffmpeg, x264, libvpx, pil, libwebp }:

buildPythonPackage rec {
  name = "xpra-0.9.5";

  src = fetchurl {
    url = "http://xpra.org/src/${name}.tar.bz2";
    sha256 = "1qr9gxmfnkays9hrw2qki1jdkyxhbbkjx71gy23x423cfsxsjmiw";
  };

  buildInputs = [
    python cython pkgconfig

    xorg.libX11 xorg.renderproto xorg.libXrender xorg.libXi xorg.inputproto xorg.kbproto
    xorg.randrproto xorg.damageproto xorg.compositeproto xorg.xextproto xorg.recordproto
    xorg.xproto xorg.fixesproto xorg.libXtst xorg.libXfixes xorg.libXcomposite xorg.libXdamage
    xorg.libXrandr

    pango cairo gdk_pixbuf atk gtk glib

    ffmpeg libvpx x264 libwebp
  ];

  propagatedBuildInputs = [
    pil pygtk pygobject
  ];

  # Even after i tried monkey patching, their tests just fail, looks like
  # they don't have automated testing out of the box? http://xpra.org/trac/ticket/177
  doCheck = false;

  buildPhase = ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0) $(pkg-config --cflags xtst)"
    python ./setup.py build --enable-Xdummy
  '';

  meta = {
    homepage = http://xpra.org/;
    description = "Persistent remote applications for X";
    platforms = stdenv.lib.platforms.mesaPlatforms;
  };
}
