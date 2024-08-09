{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  pythonAtLeast,
  fetchPypi,
  fetchurl,
  substituteAll,

  # build
  autoPatchelfHook,
  attrdict,
  doxygen,
  pkg-config,
  python,
  sip,
  which,

  # runtime
  cairo,
  gst_all_1,
  gtk3,
  libGL,
  libGLU,
  libSM,
  libXinerama,
  libXtst,
  libXxf86vm,
  libglvnd,
  mesa,
  pango,
  SDL,
  webkitgtk,
  wxGTK,
  xorgproto,

  # propagates
  numpy,
  pillow,
  six,
}:

let
  waf_2_0_25 = fetchurl {
    url = "https://waf.io/waf-2.0.25";
    hash = "sha256-IRmc0iDM9gQ0Ez4f0quMjlIXw3mRmcgnIlQ5cNyOONU=";
  };
in
buildPythonPackage rec {
  pname = "wxpython";
  version = "4.2.1";
  format = "other";

  src = fetchPypi {
    pname = "wxPython";
    inherit version;
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

  postPatch = ''
    cp ${waf_2_0_25} bin/waf-2.0.25
    chmod +x bin/waf-2.0.25
    substituteInPlace build.py \
      --replace-fail "wafCurrentVersion = '2.0.24'" "wafCurrentVersion = '2.0.25'" \
      --replace-fail "wafMD5 = '698f382cca34a08323670f34830325c4'" "wafMD5 = 'a4b1c34a03d594e5744f9e42f80d969d'" \
      --replace-fail "distutils.dep_util" "setuptools.modified"
  '';

  nativeBuildInputs = [
    attrdict
    pkg-config
    setuptools
    SDL
    sip
    which
    wxGTK
  ] ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs =
    [
      wxGTK
      SDL
    ]
    ++ lib.optionals stdenv.isLinux [
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

    ${python.pythonOnBuildForHost.interpreter} build.py -v --use_syswx dox etg sip --nodoc build_py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${python.pythonOnBuildForHost.interpreter} setup.py install --skip-build --prefix=$out
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
