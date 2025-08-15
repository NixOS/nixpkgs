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
  typing-extensions,

  # tests
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  hypothesis,
  aiohttp,
  fsspec,
  moto,
  requests,
  tomlkit,
  uv,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rOWxEdxp1TFcsWVd/Q+BbFrPl5jSrZL0O2CKUsjIrCs=";
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
    typing-extensions
  ]
  ++ numcodecs.optional-dependencies.crc32c;

  optional-dependencies = {
    remote = [ fsspec ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    hypothesis
    aiohttp
    moto
    requests
    tomlkit
    uv
    writableTmpDirAsHomeHook
  ]
  ++ moto.optional-dependencies.s3
  ++ moto.optional-dependencies.server
  ++ optional-dependencies.remote;
  pytestFlagsArray = [
    # Don't measure the time it takes for hypothesis related tests to succeed.
    # See https://github.com/astropy/astropy/issues/17649 for a similar
    # discussion, and see:
    # https://github.com/zarr-developers/zarr-python/blob/v3.0.4/tests/conftest.py#L182C1-L187C2
    "--hypothesis-profile=ci"
  ];
  disabledTests = [
    # 3 tests that require multiple Python versions to co-exist
    "test_scripts_can_run"
    "test_roundtrip_v2"
    "test_roundtrip_v3"
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
