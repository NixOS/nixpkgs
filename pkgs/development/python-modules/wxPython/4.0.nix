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
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d0dfc0146c24749ce00d575e35cc2826372e809d5bc4a57bde6c89031b59e75";
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