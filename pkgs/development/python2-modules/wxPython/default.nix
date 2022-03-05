{ fetchurl
, lib
, stdenv
, darwin
, openglSupport ? true
, libX11
, wxGTK
, wxmac
, pkg-config
, buildPythonPackage
, pyopengl
, isPy3k
, isPyPy
, python
, cairo
, pango
}:

assert wxGTK.unicode;

buildPythonPackage rec {
  pname = "wxPython";
  version = "3.0.2.0";

  disabled = isPy3k || isPyPy;
  doCheck = false;

  src = fetchurl {
    url = "mirror://sourceforge/wxpython/wxPython-src-${version}.tar.bz2";
    sha256 = "0qfzx3sqx4mwxv99sfybhsij4b5pc03ricl73h4vhkzazgjjjhfm";
  };

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkg-config ]
    ++ (lib.optionals (!stdenv.isDarwin) [ wxGTK libX11 ])
    ++ (lib.optionals stdenv.isDarwin [ wxmac ]);

  buildInputs = [ ]
    ++ (lib.optionals (!stdenv.isDarwin) [  (wxGTK.gtk) ])
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      ApplicationServices
      AudioToolbox
      CFNetwork
      Carbon
      Cocoa
      CoreGraphics
      CoreServices
      CoreText
      DiskArbitration
      IOKit
      ImageIO
      OpenGL
      Security
    ]))
    ++ (lib.optional openglSupport pyopengl);

  preConfigure = ''
    cd wxPython
    # remove wxPython's darwin hack that interference with python-2.7-distutils-C++.patch
    substituteInPlace config.py \
      --replace "distutils.unixccompiler.UnixCCompiler = MyUnixCCompiler" ""
    # set the WXPREFIX to $out instead of the storepath of wxwidgets
    substituteInPlace config.py \
      --replace "WXPREFIX   = getWxConfigValue('--prefix')" "WXPREFIX   = '$out'"
    # this check is supposed to only return false on older systems running non-framework python
    substituteInPlace src/osx_cocoa/_core_wrap.cpp \
      --replace "return wxPyTestDisplayAvailable();" "return true;"
  '' + lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace wx/lib/wxcairo.py \
      --replace 'cairoLib = None' 'cairoLib = ctypes.CDLL("${cairo}/lib/libcairo.so")'
    substituteInPlace wx/lib/wxcairo.py \
      --replace '_dlls = dict()' '_dlls = {k: ctypes.CDLL(v) for k, v in [
        ("gdk",        "${wxGTK.gtk}/lib/libgtk-x11-2.0.so"),
        ("pangocairo", "${pango.out}/lib/libpangocairo-1.0.so"),
        ("appsvc",     None)
      ]}'
  '';

  buildPhase = "";

  installPhase = ''
    ${python.interpreter} setup.py install WXPORT=${if stdenv.isDarwin then "osx_cocoa" else "gtk2"} NO_HEADERS=0 BUILD_GLCANVAS=${if openglSupport then "1" else "0"} UNICODE=1 --prefix=$out
    wrapPythonPrograms
  '';

  passthru = { inherit wxGTK openglSupport; };
}
