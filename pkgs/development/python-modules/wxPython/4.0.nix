{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, setuptools
, pkg-config
, which
, cairo
, pango
, python
, doxygen
, ncurses
, libintl
, wxGTK
, IOKit
, Carbon
, Cocoa
, AudioToolbox
, OpenGL
, CoreFoundation
, pillow
, numpy
, six
}:

buildPythonPackage rec {
  pname = "wxPython";
  version = "4.0.7.post2";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a229e695b64f9864d30a5315e0c1e4ff5e02effede0a07f16e8d856737a0c4e";
  };

  doCheck = false;

  nativeBuildInputs = [ pkg-config which doxygen setuptools wxGTK ];

  buildInputs = [ ncurses libintl ]
  ++ (if stdenv.isDarwin
  then
    [ AudioToolbox Carbon Cocoa CoreFoundation IOKit OpenGL ]
  else
    [ wxGTK.gtk ]
  );

  propagatedBuildInputs = [
    numpy
    pillow
    six
  ];

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
  '' + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    # Remove the OSX-Only wx.webkit module
    sed -i "s/makeETGRule(.*'WXWEBKIT')/pass/" wscript
  '';

  buildPhase = ''
    ${python.interpreter} build.py -v --use_syswx dox etg --nodoc sip build_py
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --skip-build --prefix=$out
  '';

  passthru = { wxWidgets = wxGTK; };


  meta = {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = lib.licenses.wxWindows;
  };

}
