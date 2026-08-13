{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  fetchpatch,
  replaceVars,

  # build
  autoPatchelfHook,
  attrdict,
  cython,
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
  libsm,
  libxinerama,
  libxtst,
  libxxf86vm,
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

  # checks
  py,
  pytest,
  pytest-forked,
  xvfb-run,
}:

buildPythonPackage (finalAttrs: {
  pname = "wxpython";
  version = "4.2.5";
  pyproject = false;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ROg20bzNmcOHkLsDS27PcNkGD2c0MgVg98Sw0AYUR5M=";
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
      --replace-fail "distutils.dep_util" "setuptools.modified" \
      --replace-fail "runcmd(cmd, fatal=False)" "runcmd(cmd, fatal=True)" # fail when pytest reports errors
  '';

  nativeBuildInputs = [
    attrdict
    cython
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

  nativeCheckInputs = [
    py # py must be ordered before pytest (see https://github.com/pytest-dev/pytest-forked/issues/88)
    pytest
    pytest-forked
    xvfb-run
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

  # The majority of the tests require a graphical environment, but xvfb-run is available only on Linux.
  # Tests fail randomly on OfBorg and Hydra.
  doCheck = false;

  checkPhase =
    let
      # Some tests appear to be incompatible with xvfb-run.
      skippedTests = [
        "dirdlg"
        "display"
        "filectrl"
        "filedlg"
        "filedlgcustomize"
        "frame"
        "glcanvas"
        "pickers"
        "windowid"
      ];
      testArguments = lib.concatMapStringsSep " " (
        test: "--ignore unittests/test_${test}.py"
      ) skippedTests;
    in
    ''
      runHook preCheck

      HOME=$(mktemp -d) xvfb-run ${python.interpreter} build.py -v --extra_pytest='${testArguments}' test

      runHook postCheck
    '';

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
