{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pkgconfig
, which
, cairo
, pango
, python
, doxygen
, ncurses
, wxGTK
, numpy
, pillow
, six
}:

buildPythonPackage rec {
  pname = "wxPython";
  version = "4.0.7.post2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a229e695b64f9864d30a5315e0c1e4ff5e02effede0a07f16e8d856737a0c4e";
  };

  doCheck = false;

  nativeBuildInputs = [ pkgconfig which doxygen wxGTK ];
  buildInputs = [ ncurses wxGTK.gtk ];

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
  '';

  passthru = { inherit wxGTK; };


  meta = {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = lib.licenses.wxWindows;
  };

}
