{
  lib,
  buildPythonPackage,
  cmake,
  numba,
  numpy,
  numkong,
  py-cpuinfo,
  pybind11,
  pytestCheckHook,
  setuptools,
  tqdm,
  pkgs,
  stdenv,
  which,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage {
  inherit (pkgs.usearch) pname version src;
  pyproject = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace python/usearch/__init__.py \
      --replace-fail 'manager = BinaryManager(version=version)' \
        'return "${lib.getLib pkgs.usearch}/lib/libusearch_sqlite${
          if stdenv.hostPlatform.isDarwin then "" else stdenv.hostPlatform.extensions.sharedLibrary
        }"'
  '';

  nativeBuildInputs = [
    which
  ];

  buildInputs = [
    pkgs.numkong
  ];

  build-system = [
    cmake
    pybind11
    setuptools
  ];

  dependencies = [
    numkong
    numpy
    tqdm
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "usearch" ];

  nativeCheckInputs = [
    numba
    py-cpuinfo
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Numerical precision error (AssertionError)
    "test_index_clustering"
    "test_index_retrieval"
  ];

  meta = {
    inherit (pkgs.usearch.meta)
      description
      homepage
      changelog
      license
      maintainers
      ;
  };
}
