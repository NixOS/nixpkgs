{ stdenv
, buildPythonPackage
, python
, py
, isPyPy
}:

buildPythonPackage rec {
  name = "tkinter-${python.version}";
  src = py;
  format = "other";

  disabled = isPyPy;

  installPhase = ''
    # Move the tkinter module
    mkdir -p $out/${py.sitePackages}
    mv lib/${py.libPrefix}/lib-dynload/_tkinter* $out/${py.sitePackages}/
  '' + stdenv.lib.optionalString (!stdenv.isDarwin) ''
    # Update the rpath to point to python without x11Support
    old_rpath=$(patchelf --print-rpath $out/${py.sitePackages}/_tkinter*)
    new_rpath=$(sed "s#${py}#${python}#g" <<< "$old_rpath" )
    patchelf --set-rpath $new_rpath $out/${py.sitePackages}/_tkinter*
  '';

  meta = py.meta;

}
