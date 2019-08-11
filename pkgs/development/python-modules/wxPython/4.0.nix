{ lib
, buildPythonPackage
, fetchPypi
, pkgconfig
, gtk3
, libjpeg
, libtiff
, SDL
, gst-plugins-base
, libnotify
, freeglut
, xorg
, which
}:

buildPythonPackage rec {
  pname = "wxPython";
  version = "4.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35cc8ae9dd5246e2c9861bb796026bbcb9fb083e4d49650f776622171ecdab37";
  };

  nativeBuildInputs = [
    pkgconfig
  ];

  buildInputs = [
    gtk3 libjpeg libtiff SDL gst-plugins-base libnotify freeglut xorg.libSM
    which
  ];


  meta = {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = http://wxpython.org/;
    license = lib.licenses.wxWindows;
  };

}