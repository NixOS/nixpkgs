{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  asciitree,
  donfig,
  numpy,
  fasteners,
  numcodecs,

  # tests
  aiohttp,
  botocore,
  fsspec,
  hypothesis,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  rich,
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
    hatchling
    hatch-vcs
  ];

  dependencies = [
    asciitree
    donfig
    numpy
    fasteners
    numcodecs
  ] ++ numcodecs.optional-dependencies.crc32c;

  nativeCheckInputs = [
    aiohttp
    botocore
    fsspec
    hypothesis
    pytest-asyncio
    pytestCheckHook
    requests
    rich
  ];

  disabledTests = [
    # flaky
    "test_vindex"
    "test_zarr_hierarchy"
    "test_zarr_store"
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
