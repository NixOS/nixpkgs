{ lib
, stdenv
, buildPythonPackage
, setuptools
, pythonOlder
, fetchPypi
, substituteAll

# build
, autoPatchelfHook
, attrdict
, doxygen
, pkg-config
, python
, sip
, which

# runtime
, cairo
, gst_all_1
, gtk3
, libGL
, libGLU
, libSM
, libXinerama
, libXtst
, libXxf86vm
, libglvnd
, mesa
, pango
, SDL
, webkitgtk
, wxGTK
, xorgproto

# propagates
, numpy
, pillow
, six
}:

buildPythonPackage rec {
  pname = "wxPython";
  version = "4.2.1";
  format = "other";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5I3iEaZga/By7D+neHcda3RsALf0uXDrWHKN31bRPVw=";
  };

  patches = [
    (substituteAll {
      src = ./4.2-ctypes.patch;
      libgdk = "${gtk3.out}/lib/libgdk-3.so";
      libpangocairo = "${pango}/lib/libpangocairo-1.0.so";
      libcairo = "${cairo}/lib/libcairo.so";
    })
  ];

  nativeBuildInputs = [
    attrdict
    pkg-config
    setuptools
    SDL
    sip
    which
    wxGTK
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    wxGTK
    SDL
  ] ++ lib.optionals stdenv.isLinux [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libGL
    libGLU
    libSM
    libXinerama
    libXtst
    libXxf86vm
    libglvnd
    mesa
    webkitgtk
    xorgproto
  ];

  propagatedBuildInputs = [
    numpy
    pillow
    six
  ];

  buildPhase = ''
    runHook preBuild

    export DOXYGEN=${doxygen}/bin/doxygen
    export PATH="${wxGTK}/bin:$PATH"
    export SDL_CONFIG="${SDL.dev}/bin/sdl-config"

    ${python.pythonForBuild.interpreter} build.py -v --use_syswx dox etg sip --nodoc build_py

    runHook postBuild
  '';


  installPhase = ''
    runHook preInstall

    ${python.pythonForBuild.interpreter} setup.py install --skip-build --prefix=$out
    wrapPythonPrograms

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} build.py -v test

    runHook postCheck
  '';


  meta = with lib; {
    changelog = "https://github.com/wxWidgets/Phoenix/blob/wxPython-${version}/CHANGES.rst";
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = licenses.wxWindows;
    maintainers = with maintainers; [ hexa ];
  };
}
