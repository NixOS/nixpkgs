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
  version = "4.0.7.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "da43eaa2eea32c34a52531331b0a69bd791c237803a7c5df451509624766f7ca";
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
