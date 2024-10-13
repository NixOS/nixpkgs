{
  lib,
  stdenv,
  buildPythonPackage,
  python,
  ndtypes,
  libndtypes,
  libxnd,
  isPy27,
}:

buildPythonPackage {
  pname = "xnd";
  format = "setuptools";
  disabled = isPy27;
  inherit (libxnd) version src meta;

  propagatedBuildInputs = [ ndtypes ];

  buildInputs = [ libndtypes ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'include_dirs = ["libxnd", "ndtypes/python/ndtypes"] + INCLUDES' \
                'include_dirs = ["${libndtypes}/include", "${ndtypes}/include", "${libxnd}/include"]' \
      --replace 'library_dirs = ["libxnd", "ndtypes/libndtypes"] + LIBS' \
                'library_dirs = ["${libndtypes}/lib", "${libxnd}/lib"]' \
      --replace 'runtime_library_dirs = ["$ORIGIN"]' \
                'runtime_library_dirs = ["${libndtypes}/lib", "${libxnd}/lib"]' \
  '';

  postInstall =
    ''
      mkdir $out/include
      cp python/xnd/*.h $out/include
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -add_rpath ${libxnd}/lib $out/${python.sitePackages}/xnd/_xnd.*.so
    '';

  checkPhase = ''
    pushd python
    mv xnd _xnd
    python test_xnd.py
    popd
  '';
}
