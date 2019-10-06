{ lib
, stdenv
, openglSupport ? true
, libX11
, pyopengl
, buildPythonPackage
, fetchPypi
, pkgconfig
, libjpeg
, libtiff
, SDL
, gst-plugins-base
, libnotify
, freeglut
, xorg
, which
, cairo
, requests
, pango
, pathlib2
, python
, doxygen
, ncurses
, libpng
, gstreamer
, wxGTK
}:

buildPythonPackage rec {
  pname = "wxPython";
  version = "4.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "35cc8ae9dd5246e2c9861bb796026bbcb9fb083e4d49650f776622171ecdab37";
  };

  doCheck = false;

  nativeBuildInputs = [ pkgconfig which doxygen wxGTK ];

  buildInputs = [ libjpeg libtiff SDL
      gst-plugins-base libnotify freeglut xorg.libSM ncurses
      requests libpng gstreamer libX11
      pathlib2
      (wxGTK.gtk)
  ]
    ++ lib.optional openglSupport pyopengl;

  hardeningDisable = [ "format" ];

  DOXYGEN = "${doxygen}/bin/doxygen";

  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace wx/lib/wxcairo/wx_pycairo.py \
      --replace 'cairoLib = None' 'cairoLib = ctypes.CDLL("${cairo}/lib/libcairo.so")'
    substituteInPlace wx/lib/wxcairo/wx_pycairo.py \
      --replace '_dlls = dict()' '_dlls = {k: ctypes.CDLL(v) for k, v in [
        ("gdk",        "${wxGTK.gtk}/lib/libgtk-x11-2.0.so"),
        ("pangocairo", "${pango.out}/lib/libpangocairo-1.0.so"),
        ("appsvc",     None)
      ]}'
  '';

  buildPhase = ''
    ${python.interpreter} build.py -v --use_syswx dox etg --nodoc sip build_py
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --skip-build --prefix=$out
    wrapPythonPrograms
  '';

  passthru = { inherit wxGTK openglSupport; };


  meta = {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = http://wxpython.org/;
    license = lib.licenses.wxWindows;
  };

}
