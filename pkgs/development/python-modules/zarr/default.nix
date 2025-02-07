{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools-scm,

  # dependencies
  asciitree,
  numpy,
  fasteners,
  numcodecs,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "2.18.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JYDYy23YRiF3GhDTHE13fcqKJ3BqGomyn0LS034t9c4=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    asciitree
    numpy
    fasteners
    numcodecs
  ] ++ numcodecs.optional-dependencies.msgpack;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zarr" ];

  meta = {
    description = "Implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
