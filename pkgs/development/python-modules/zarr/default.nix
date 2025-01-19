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
  version = "3.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AzhZxWA9ycKeU69JTt4ktC8bdh0rtiVGaZCjuKmvt5I=";
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
