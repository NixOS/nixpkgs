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

  # checks
  py,
  pytest,
  pytest-forked,
  xvfb-run,
}:

buildPythonPackage rec {
  pname = "wxpython";
  version = "4.2.4";
  format = "other";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LrEjl5yHvLMp6KJFImnWD/j59lHpvyXGdXnlPE67rjw=";
  };

  patches = [
    (replaceVars ./4.2-ctypes.patch {
      libgdk = "${lib.getLib gtk3}/lib/libgdk-3${stdenv.hostPlatform.extensions.sharedLibrary}";
      libpangocairo = "${lib.getLib pango}/lib/libpangocairo-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      libcairo = "${lib.getLib cairo}/lib/libcairo${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
    ./0001-add-missing-bool-c.patch # Add missing bool.c from old source
    # TODO: drop when updating beyond version 4.2.4
    # https://github.com/wxWidgets/Phoenix/pull/2822
    (fetchpatch {
      name = "Fix-wx.svg-to-work-with-cython-3.1-generated-code.patch";
      url = "https://github.com/wxWidgets/Phoenix/commit/31303649ab0a0fed0789e0951a7487d172b65bfa.patch";
      hash = "sha256-OAnAsyqHGPNEAiOxLLpdEGcd92K7TCxqEBYceuIb8so=";
    })
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
  # Tests on aarch64-linux fail randomly on OfBorg.
  doCheck = stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isLinux;

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
