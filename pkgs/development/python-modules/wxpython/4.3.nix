{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  replaceVars,

  # build
  autoPatchelfHook,
  cython,
  pkg-config,
  python,
  which,

  # runtime
  cairo,
  gst_all_1,
  gtk3,
  libGL,
  libGLU,
  libsm,
  libxinerama,
  libxtst,
  libxxf86vm,
  libglvnd,
  libgbm,
  pango,
  webkitgtk_4_1,
  wxwidgets_3_3,
  xorgproto,

  # propagates
  numpy,
  pillow,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "wxpython";
  version = "4.3.2";
  pyproject = false;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VTG6qTREiKFQgaay6utnrwR9EqgUz2V8CCNgzMNyBPs=";
  };

  patches = [
    (replaceVars ./4.2-ctypes.patch {
      libgdk = "${lib.getLib gtk3}/lib/libgdk-3${stdenv.hostPlatform.extensions.sharedLibrary}";
      libpangocairo = "${lib.getLib pango}/lib/libpangocairo-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      libcairo = "${lib.getLib cairo}/lib/libcairo${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    cython
    pkg-config
    setuptools
    which
    wxwidgets_3_3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    wxwidgets_3_3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libGL
    libGLU
    libsm
    libxinerama
    libxtst
    libxxf86vm
    libglvnd
    libgbm
    webkitgtk_4_1
    xorgproto
  ];

  propagatedBuildInputs = [
    numpy
    pillow
    six
  ];

  buildPhase = ''
    runHook preBuild

    export PATH="${wxwidgets_3_3}/bin:$PATH"

    ${python.pythonOnBuildForHost.interpreter} build.py -v --use_syswx build_py

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${python.pythonOnBuildForHost.interpreter} setup.py install --skip-build --prefix=$out
    wrapPythonPrograms

    runHook postInstall
  '';

  # The majority of the tests require a graphical environment.
  doCheck = false;

  pythonImportsCheck = [ "wx" ];

  meta = {
    changelog = "https://github.com/wxWidgets/Phoenix/blob/wxPython-${finalAttrs.version}/CHANGES.rst";
    description = "Cross platform GUI toolkit for Python, Phoenix version";
    homepage = "http://wxpython.org/";
    license = with lib.licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
  };
})
