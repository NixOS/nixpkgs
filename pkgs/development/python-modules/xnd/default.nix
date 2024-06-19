{
  lib,
  stdenv,
  fetchpatch,
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

  patches = [
    # python311 fixes which are on main. remove on update
    (fetchpatch {
      name = "python311.patch";
      url = "https://github.com/xnd-project/xnd/commit/e1a06d9f6175f4f4e1da369b7e907ad6b2952c00.patch";
      hash = "sha256-xzrap+FL5be13bVdsJ3zeV7t57ZC4iyhuZhuLsOzHyE=";
    })
  ];

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
    + lib.optionalString stdenv.isDarwin ''
      install_name_tool -add_rpath ${libxnd}/lib $out/${python.sitePackages}/xnd/_xnd.*.so
    '';

  checkPhase = ''
    pushd python
    mv xnd _xnd
    python test_xnd.py
    popd
  '';
}
