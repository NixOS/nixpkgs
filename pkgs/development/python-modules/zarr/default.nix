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
}:

buildPythonPackage rec {
  pname = "zarr";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A2stq/+p8BSMrVenvmxp2XYfazuDO2G30pwu6Kg2tGw=";
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
  ] ++ numcodecs.optional-dependencies.crc32c;

  optional-dependencies = {
    remote = [ fsspec ];
  };

  nativeCheckInputs =
    [
      pytestCheckHook
      pytest-asyncio
      pytest-cov-stub
      hypothesis
      aiohttp
      moto
      requests
    ]
    ++ moto.optional-dependencies.s3
    ++ moto.optional-dependencies.server
    ++ optional-dependencies.remote;

  pythonImportsCheck = [ "zarr" ];

  meta = {
    description = "Implementation of chunked, compressed, N-dimensional arrays for Python";
    homepage = "https://github.com/zarr-developers/zarr";
    changelog = "https://github.com/zarr-developers/zarr-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
