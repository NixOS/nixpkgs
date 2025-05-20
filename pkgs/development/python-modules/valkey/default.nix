{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  async-timeout,

  # optional-dependencies
  cryptography,
  pyopenssl,
  requests,

  # tests
  cachetools,
  mock,
  packaging,
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,
  redisTestHook,
  ujson,
  uvloop,
}:

buildPythonPackage rec {
  pname = "valkey";
  version = "6.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey-py";
    tag = "v${version}";
    hash = "sha256-TaAkifgasirA72OSO+up0+1EUhCENKba7vPIJxhTkh8=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.11") [ async-timeout ];

  optional-dependencies = {
    # TODO: libvalkey = [ libvalkey ];
    ocsp = [
      cryptography
      pyopenssl
      requests
    ];
  };

  pythonImportsCheck = [
    "valkey"
    "valkey.client"
    "valkey.cluster"
    "valkey.connection"
    "valkey.exceptions"
    "valkey.sentinel"
    "valkey.utils"
  ];

  nativeCheckInputs = [
    cachetools
    mock
    packaging
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
    redisTestHook
    ujson
    uvloop
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [ "-m 'not onlycluster and not ssl'" ];

  disabledTests = [
    # valkey.sentinel.MasterNotFoundError: No master found for 'valkey-py-test'
    "test_get_from_cache"
    "test_cache_decode_response"
    # Expects another valkey instance on port 6380 *shrug*
    "test_psync"
  ];

  meta = with lib; {
    description = "Python client for Redis key-value store";
    homepage = "https://github.com/valkey-io/valkey-py";
    changelog = "https://github.com/valkey-io/valkey-py/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hexa ];
  };
}
