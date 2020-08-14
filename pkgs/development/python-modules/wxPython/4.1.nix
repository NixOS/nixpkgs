{ lib
, stdenv
, openglSupport ? true

, fetchPypi
, buildPythonPackage
, which
, pkgconfig
, gtk3
, pkg-config

, python
, isPy27
, freeglut
, gst_all_1
, libpng
, libtiff
, libjpeg
, libnotify
, SDL2
, xorg

, libX11
, pyopengl
, requests
, doxygen
, cairo
, ncurses
, pango
, pathlib2

, libGLU
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

  nativeBuildInputs = [ which doxygen gtk3 pkg-config ];

  buildInputs = [
    freeglut
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libpng
    libtiff
    libjpeg
    libnotify
    SDL2
    xorg.libSM
    xorg.libXtst
    gtk3
    ncurses
    requests
    libX11
    pathlib2
    libGLU
  ]
  ++ lib.optional openglSupport pyopengl;

  hardeningDisable = [ "format" ];

  DOXYGEN = "${doxygen}/bin/doxygen";

  preConfigure = lib.optionalString (!stdenv.isDarwin) ''
    substituteInPlace wx/lib/wxcairo/wx_pycairo.py \
      --replace 'cairoLib = None' 'cairoLib = ctypes.CDLL("${cairo}/lib/libcairo.so")'
    substituteInPlace wx/lib/wxcairo/wx_pycairo.py \
      --replace '_dlls = dict()' '_dlls = {k: ctypes.CDLL(v) for k, v in [
        ("gdk",        "${gtk3}/lib/libgtk-x11-3.0.so"),
        ("pangocairo", "${pango.out}/lib/libpangocairo-1.0.so"),
        ("appsvc",     None)
      ]}'

    # https://github.com/wxWidgets/Phoenix/pull/1584
    substituteInPlace build.py --replace "os.environ['PYTHONPATH'] = phoenixDir()" \
      "os.environ['PYTHONPATH'] = os.environ['PYTHONPATH'] + os.pathsep + phoenixDir()"
  '';

  buildPhase = ''
    ${python.interpreter} build.py -v build
  '';

  installPhase = ''
    ${python.interpreter} setup.py install --skip-build --prefix=$out
    wrapPythonPrograms
  '';

  shellHook = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}$out/${python.sitePackages}/wx
  '';

  preFixup = ''
    for i in $out/${python.sitePackages}/wx/*.so; do
      patchelf --set-rpath "$out/${python.sitePackages}/wx:$(patchelf --print-rpath $i)" $i
    done

    for i in $out/${python.sitePackages}/wx/lib/*.so; do
      patchelf --set-rpath "$out/${python.sitePackages}/wx/lib:$(patchelf --print-rpath $i)" $i
    done
  '';

  passthru = { inherit openglSupport; };

  meta = with lib; {
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ tfmoraes ];
  };

}
