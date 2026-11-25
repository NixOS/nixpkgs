{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # optional-dependencies
  cryptography,
  libvalkey,
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

buildPythonPackage (finalAttrs: {
  pname = "valkey";
  version = "6.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xGQvJwDu3SYuGhaB/WNaorV+AGXxceKPMxptQhsTlPY=";
  };

  patches = [
    # valkey 9.2 compat, backport of
    # https://github.com/valkey-io/valkey-py/commit/e87c922292a3d199ef6a2a1502a0607e14fe8b39
    ./valkey-9.2-module-load-error.patch
  ];

  build-system = [ hatchling ];

  optional-dependencies = {
    libvalkey = [ libvalkey ];
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTestMarks = [
    "onlycluster"
    "ssl"
  ];

  disabledTests = [
    # Expects another valkey instance on port 6380 *shrug*
    "test_psync"
    # valkey 9.2 reports the stream length as lag for a group positioned
    # before the first entry (valkey-io/valkey#4983), the test expects -6
    "test_xgroup_create_entries_read"
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
    changelog = "https://github.com/valkey-io/valkey-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
