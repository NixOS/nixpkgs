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
  version = "4.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d9ef4260cb2f3e23ed9dcf6baa905ba585ac7d631613cddc299c4c83463ae29";
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