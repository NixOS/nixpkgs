{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  replaceVars,

  # build
  autoPatchelfHook,
  attrdict,
  doxygen,
  pkg-config,
  python,
  requests,
  sip,
  which,
  buildPackages,

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
  libgbm,
  pango,
  webkitgtk_4_1,
  wxGTK,
  xorgproto,

  # propagates
  numpy,
  pillow,
  six,
}:

buildPythonPackage rec {
  pname = "wxpython";
  version = "4.2.3";
  format = "other";

  src = fetchPypi {
    pname = "wxPython";
    inherit version;
    hash = "sha256-INbgySfifO2FZDcZvWPp9/1QHfbpqKqxSJsDmJf9fAE=";
  };

  patches = [
    (replaceVars ./4.2-ctypes.patch {
      libgdk = "${lib.getLib gtk3}/lib/libgdk-3${stdenv.hostPlatform.extensions.sharedLibrary}";
      libpangocairo = "${lib.getLib pango}/lib/libpangocairo-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      libcairo = "${lib.getLib cairo}/lib/libcairo${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
    ./0001-add-missing-bool-c.patch # Add missing bool.c from old source
  ];

  # https://github.com/wxWidgets/Phoenix/issues/2575
  postPatch = ''
    ln -s ${lib.getExe buildPackages.waf} bin/waf
    substituteInPlace build.py \
      --replace-fail "distutils.dep_util" "setuptools.modified"
  '';

  nativeBuildInputs = [
    attrdict
    pkg-config
    requests
    setuptools
    sip
    which
    wxGTK
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    wxGTK
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
    libGL
    libGLU
    libSM
    libXinerama
    libXtst
    libXxf86vm
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

  wafPath = "bin/waf";

  buildPhase = ''
    runHook preBuild

    export DOXYGEN=${doxygen}/bin/doxygen
    export PATH="${wxGTK}/bin:$PATH"

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
    license = with licenses; [
      lgpl2Plus
      wxWindowsException31
    ];
    maintainers = with maintainers; [ hexa ];
  };
}
