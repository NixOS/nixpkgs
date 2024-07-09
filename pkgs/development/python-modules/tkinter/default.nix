{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  py,
  isPyPy,
}:

buildPythonPackage {
  pname = "tkinter";
  version = python.version;
  src = py;
  format = "other";

  disabled = isPyPy;

  installPhase =
    ''
      # Move the tkinter module
      mkdir -p $out/${py.sitePackages}
      mv lib/${py.libPrefix}/lib-dynload/_tkinter* $out/${py.sitePackages}/
    ''
    + lib.optionalString (!stdenv.isDarwin) ''
      # Update the rpath to point to python without x11Support
      old_rpath=$(patchelf --print-rpath $out/${py.sitePackages}/_tkinter*)
      new_rpath=$(sed "s#${py}#${python}#g" <<< "$old_rpath" )
      patchelf --set-rpath $new_rpath $out/${py.sitePackages}/_tkinter*
    '';

  meta = py.meta // {
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
  };
}
