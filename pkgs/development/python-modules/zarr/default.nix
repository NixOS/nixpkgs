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
  version = "2.18.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-srj2bxTaxK9msYDSM4gZmBuYH3Dhlsmmbmv6qeWVcvU=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    asciitree
    numpy
    fasteners
    numcodecs
  ]
  ++ numcodecs.optional-dependencies.msgpack;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zarr" ];

  # FIXME remove once zarr's reverse dependencies support v3
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
