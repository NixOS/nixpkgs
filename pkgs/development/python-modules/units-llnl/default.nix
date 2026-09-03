{
  lib,
  buildPythonPackage,
  units-llnl,

  # build-system
  nanobind,
  scikit-build-core,

  # nativeBuildInputs
  cmake,
  # NOTE that if top-level units-llnl package uses cmakeFlags other then
  # Nixpkgs' default, the build might fail, and you'd want to pick only the
  # cmakeFlags that don't cause a failure. See also:
  # https://github.com/scipp/scipp/issues/3705
  cmakeFlags ? units-llnl.cmakeFlags,
  ninja,
}:

buildPythonPackage {
  inherit (units-llnl)
    pname
    version
    src
    meta
    ;
  pyproject = true;

  build-system = [
    nanobind
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];
  dontUseCmakeConfigure = true;
  cmakeFlags = cmakeFlags ++ [
    (lib.cmakeBool "UNITS_BUILD_PYTHON_LIBRARY" true)
  ];

  # Also upstream turns off testing for the python build so it seems, see:
  # https://github.com/LLNL/units/blob/v0.13.1/pyproject.toml#L65-L66 However
  # they do seem to use pytest for their CI, but in our case it fails due to
  # missing googletest Python modules, which we don't know how to build.
  doCheck = false;
  passthru = {
    top-level = units-llnl;
  };
}
