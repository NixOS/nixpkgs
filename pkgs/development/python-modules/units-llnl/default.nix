{
  lib,
  buildPythonPackage,
  units-llnl,

  # build-system
  nanobind,
  scikit-build-core,

  # nativeBuildInputs
  cmake,
  cmakeFlags ? [ ],
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
  env = {
    SKBUILD_CMAKE_ARGS = lib.strings.concatStringsSep ";" (
      # NOTE: Intentionally not using units-llnl.cmakeFlags here, as this will
      # result in a failing build. A user of this Python package can take the
      # flags from there that don't cause a build failure if they wish to. See also:
      # https://github.com/scipp/scipp/issues/3705
      cmakeFlags
      ++ [
        (lib.cmakeBool "UNITS_BUILD_PYTHON_LIBRARY" true)
      ]
    );
  };

  # Also upstream turns off testing for the python build so it seems, see:
  # https://github.com/LLNL/units/blob/v0.13.1/pyproject.toml#L65-L66 However
  # they do seem to use pytest for their CI, but in our case it fails due to
  # missing googletest Python modules, which we don't know how to build.
  doCheck = false;
  passthru = {
    top-level = units-llnl;
  };
}
