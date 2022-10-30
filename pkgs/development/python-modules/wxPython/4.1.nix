{ lib
, stdenv
, fetchPypi
, fetchpatch
, buildPythonPackage
, setuptools
, which
, pkg-config
, python
, isPy27
, doxygen
, cairo
, ncurses
, pango
, wxGTK
, gtk3
, AGL
, AudioToolbox
, AVFoundation
, AVKit
, Carbon
, Cocoa
, CoreFoundation
, CoreMedia
, IOKit
, Kernel
, OpenGL
, Security
, WebKit
, pillow
, numpy
, six
, libXinerama
, libSM
, libXxf86vm
, libXtst
, libGLU
, libGL
, xorgproto
, gst_all_1
, libglvnd
, mesa
, webkitgtk
, autoPatchelfHook
}:
let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;
in
buildPythonPackage rec {
  pname = "wxPython";
  version = "4.1.1";
  disabled = isPy27;
  format = "other";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a1mdhdkda64lnwm1dg0dlrf9rs4gkal3lra6hpqbwn718cf7r80";
  };

  # ld: framework not found System
  postPatch = ''
    for file in ext/wxWidgets/configure*; do
      substituteInPlace $file --replace "-framework System" ""
    done
  '';

  # https://github.com/NixOS/nixpkgs/issues/75759
  # https://github.com/wxWidgets/Phoenix/issues/1316
  doCheck = false;

  nativeBuildInputs = [
    which
    doxygen
    gtk3
    pkg-config
    setuptools
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    ncurses
  ] ++ lib.optionals stdenv.isLinux [
    libXinerama
    libSM
    libXxf86vm
    libXtst
    xorgproto
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libGLU
    libGL
    libglvnd
    mesa
    webkitgtk
  ] ++ lib.optionals stdenv.isDarwin [
    AGL
    AudioToolbox
    AVFoundation
    AVKit
    Carbon
    Cocoa
    CoreFoundation
    CoreMedia
    IOKit
    Kernel
    OpenGL
    Security
    WebKit
  ];

  propagatedBuildInputs = [
    pillow
    numpy
    six
  ];

  DOXYGEN = "${doxygen}/bin/doxygen";

  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace wx/lib/wxcairo/wx_pycairo.py \
      --replace '_dlls = dict()' '_dlls = {k: ctypes.CDLL(v) for k, v in [
        ("gdk",        "${gtk3}/lib/libgtk-x11-3.0.so"),
        ("pangocairo", "${pango.out}/lib/libpangocairo-1.0.so"),
        ("cairoLib = None", "cairoLib = ctypes.CDLL('${cairo}/lib/libcairo.so')"),
        ("appsvc",     None)
      ]}'
  '';

  buildPhase = ''
    ${python.interpreter} build.py -v build_wx dox etg --nodoc sip build_py
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --skip-build --prefix=$out
    wrapPythonPrograms
  '';

  meta = with lib; {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ tfmoraes ];
  };
}
