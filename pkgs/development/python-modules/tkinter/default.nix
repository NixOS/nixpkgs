{
  lib,
  stdenv,
  buildPythonPackage,
  replaceVars,
  setuptools,
  python,
  pythonOlder,
  tcl,
  tclPackages,
  tk,
  xvfb-run,
}:

buildPythonPackage {
  pname = "tkinter";
  version = python.version;
  pyproject = true;

  src = python.src;

  prePatch = ''
    mkdir $NIX_BUILD_TOP/tkinter

    # copy the module bits and pieces from the python source
    cp -v  Modules/{_tkinter.c,tkinter.h} ../tkinter/
    cp -rv Modules/clinic ../tkinter/
    cp -rv Lib/tkinter ../tkinter/

    # install our custom pyproject.toml
    cp ${
      replaceVars ./pyproject.toml {
        python_version = python.version;
        python_internal_dir = "${python}/include/${python.libPrefix}/internal";
      }
    } $NIX_BUILD_TOP/tkinter/pyproject.toml

  ''
  + lib.optionalString (pythonOlder "3.13") ''
    substituteInPlace "$NIX_BUILD_TOP/tkinter/tkinter/tix.py" --replace-fail \
      "os.environ.get('TIX_LIBRARY')" \
      "os.environ.get('TIX_LIBRARY') or '${tclPackages.tix}/lib'"
  '';

  # Adapted from https://github.com/python/cpython/pull/124542
  patches = lib.optional (pythonOlder "3.12") ./fix-ttk-notebook-test.patch;

  preConfigure = ''
    pushd $NIX_BUILD_TOP/tkinter
  '';

  build-system = [ setuptools ];

  buildInputs = [
    tcl
    tk
  ];

  env = {
    TCLTK_LIBS = toString [
      "-L${lib.getLib tcl}/lib"
      "-L${lib.getLib tk}/lib"
      "-l${tcl.libPrefix}"
      "-l${tk.libPrefix}"
    ];
    TCLTK_CFLAGS = toString [
      "-I${lib.getDev tcl}/include"
      "-I${lib.getDev tk}/include"
    ];
  };

  nativeCheckInputs = lib.optional stdenv.hostPlatform.isLinux xvfb-run;

  preCheck = ''
    cd $NIX_BUILD_TOP/Python-*/Lib
    export HOME=$TMPDIR
  '';

  checkPhase =
    let
      testsNoGui = [
        "test.test_tcl"
        "test.test_ttk_textonly"
      ];
      testsGui =
        if pythonOlder "3.12" then
          [
            "test.test_tk"
            "test.test_ttk_guionly"
          ]
        else
          [
            "test.test_tkinter"
            "test.test_ttk"
          ];
    in
    ''
      runHook preCheck
      ${python.interpreter} -m unittest ${lib.concatStringsSep " " testsNoGui}
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      xvfb-run -w 10 -s "-screen 0 1920x1080x24" \
        ${python.interpreter} -m unittest ${lib.concatStringsSep " " testsGui}
    ''
    + ''
      runHook postCheck
    '';

  pythonImportsCheck = [ "tkinter" ];

  meta = {
    # Based on first sentence from https://docs.python.org/3/library/tkinter.html
    description = "Standard Python interface to the Tcl/Tk GUI toolkit";
    longDescription = ''
      The tkinter package (“Tk interface”) is the standard Python interface to
      the Tcl/Tk GUI toolkit. Both Tk and tkinter are available on most Unix
      platforms, including macOS, as well as on Windows systems.

      Running python -m tkinter from the command line should open a window
      demonstrating a simple Tk interface, letting you know that tkinter is
      properly installed on your system, and also showing what version of
      Tcl/Tk is installed, so you can read the Tcl/Tk documentation specific to
      that version.

      Tkinter supports a range of Tcl/Tk versions, built either with or without
      thread support. The official Python binary release bundles Tcl/Tk 8.6
      threaded. See the source code for the _tkinter module for more
      information about supported versions.

      Tkinter is not a thin wrapper, but adds a fair amount of its own logic to
      make the experience more pythonic. This documentation will concentrate on
      these additions and changes, and refer to the official Tcl/Tk
      documentation for details that are unchanged.
    '';
    homepage = "https://docs.python.org/3/library/tkinter.html";
    inherit (python.meta)
      license
      maintainers
      ;
  };
}
