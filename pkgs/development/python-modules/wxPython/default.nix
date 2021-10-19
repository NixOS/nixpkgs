{ lib
, stdenv
, fetchPypi
, buildPythonPackage
, which
, pkg-config
, python
, isPy27
, doxygen
, cairo
, ncurses
, pango
, wxGTK
, pillow
, numpy
}:
let
  dynamic-linker = stdenv.cc.bintools.dynamicLinker;
in
buildPythonPackage rec {
  pname = "wxPython";
  version = "4.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "12x4ci5q7qni4rkfiq6lnpn1fk8b0sfc6dck5wyxkj2sfp5pa91f";
  };

  # https://github.com/NixOS/nixpkgs/issues/75759
  # https://github.com/wxWidgets/Phoenix/issues/1316
  doCheck = false;

  nativeBuildInputs = [ which doxygen wxGTK pkg-config ];

  buildInputs = [
    wxGTK.gtk
    ncurses
  ];

  propagatedBuildInputs = [ pillow numpy ];

  DOXYGEN = "${doxygen}/bin/doxygen";

  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace wx/lib/wxcairo/wx_pycairo.py \
      --replace 'cairoLib = None' 'cairoLib = ctypes.CDLL("${cairo}/lib/libcairo.so")'
    substituteInPlace wx/lib/wxcairo/wx_pycairo.py \
      --replace '_dlls = dict()' '_dlls = {k: ctypes.CDLL(v) for k, v in [
        ("gdk",        "${wxGTK.gtk}/lib/libgtk-x11-3.0.so"),
        ("pangocairo", "${pango.out}/lib/libpangocairo-1.0.so"),
        ("appsvc",     None)
      ]}'

    # https://github.com/wxWidgets/Phoenix/pull/1584
    # It'll be not needed in next version because https://github.com/wxWidgets/Phoenix/pull/1699
    substituteInPlace build.py --replace "os.environ['PYTHONPATH'] = phoenixDir()" \
      "os.environ['PYTHONPATH'] = os.environ['PYTHONPATH'] + os.pathsep + phoenixDir()"
  '';

  buildPhase = ''
    ${python.interpreter} build.py -v --use_syswx dox etg --nodoc build_py
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --skip-build --prefix=$out
    wrapPythonPrograms
  '';

  passthru = { inherit wxGTK; };

  meta = with lib; {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ tfmoraes ];
  };
}
