{
  lib,
  buildPythonPackage,
  replaceVars,
  setuptools,
  python,
  pythonOlder,
  tcl,
  tclPackages,
  tk,
  tkinter,
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

    pushd $NIX_BUILD_TOP/tkinter

    # install our custom pyproject.toml
    cp ${
      replaceVars ./pyproject.toml {
        python_version = python.version;
        python_internal_dir = "${python}/include/${python.libPrefix}/internal";
      }
    } ./pyproject.toml

  ''
  + lib.optionalString (pythonOlder "3.13") ''
    substituteInPlace "tkinter/tix.py" --replace-fail \
      "os.environ.get('TIX_LIBRARY')" \
      "os.environ.get('TIX_LIBRARY') or '${tclPackages.tix}/lib'"
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

  doCheck = false;

  nativeCheckInputs = [ xvfb-run ];

  preCheck = ''
    cd $NIX_BUILD_TOP/Python-*/Lib
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run -w 10 -s "-screen 0 1920x1080x24" \
      python -m unittest test.test_tkinter

    runHook postCheck
  '';

  passthru.tests.unittests = tkinter.overridePythonAttrs { doCheck = true; };

  pythonImportsCheck = [ "tkinter" ];

  meta = {
    broken = pythonOlder "3.12"; # tommath.h: No such file or directory
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
