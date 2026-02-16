{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  pythonOlder,

  # build-system
  setuptools,

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
  version = "6.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey-py";
    tag = "v${version}";
    hash = "sha256-woJYfgLNIVzTYj9q8IjXo+SXhQZkQdB/Ofv5StGy9Rc=";
  };

  patches = [
    (fetchpatch {
      # valkey 9.0 compat
      url = "https://github.com/valkey-io/valkey-py/commit/c01505e547f614f278b882a016557b6ed652bb9f.patch";
      hash = "sha256-rvA65inIioqdc+QV4KaaUv1I/TMZUq0TWaFJcJiy8NU=";
    })
  ];

  build-system = [ setuptools ];

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
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestMarks = [
    "onlycluster"
    "ssl"
  ];

  disabledTests = [
    # valkey.sentinel.MasterNotFoundError: No master found for 'valkey-py-test'
    "test_get_from_cache"
    "test_cache_decode_response"
    # Expects another valkey instance on port 6380 *shrug*
    "test_psync"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    #  OSError: AF_UNIX path too long
    "test_uds_connect"
    "test_network_connection_failure"
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    # multiple disconnects are counted instead of just one
    "test_valkey_from_pool"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # AttributeError: Can't get local object 'TestMultiprocessing.test_valkey_client.<locals>.target'
    "tests/test_multiprocessing.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python client for Redis key-value store";
    homepage = "https://github.com/valkey-io/valkey-py";
    changelog = "https://github.com/valkey-io/valkey-py/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
