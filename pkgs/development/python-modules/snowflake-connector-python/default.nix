{
  lib,
  aioboto3,
  aiohttp,
  asn1crypto,
  buildPythonPackage,
  boto3,
  botocore,
  certifi,
  charset-normalizer,
  cryptography,
  cython,
  fetchFromGitHub,
  filelock,
  idna,
  keyring,
  numpy,
  packaging,
  pandas,
  platformdirs,
  pyarrow,
  pyjwt,
  pyopenssl,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  pytz,
  requests,
  responses,
  setuptools,
  sortedcontainers,
  tomlkit,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "4.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-bJK6U5lomcPMGeKEmv+9m+uM5+3GJKKUA3dEwP/ynVo=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    asn1crypto
    certifi
    charset-normalizer
    cryptography
    filelock
    idna
    packaging
    platformdirs
    pyjwt
    pyopenssl
    pytz
    requests
    sortedcontainers
    tomlkit
    typing-extensions
  ];

  pythonRelaxDeps = [
    "pyopenssl"
  ];

  optional-dependencies = {
    boto = [
      boto3
      botocore
    ];
    pandas = [
      pandas
      pyarrow
    ];
    secure-local-storage = [ keyring ];
  };

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    aioboto3
    aiohttp
    numpy
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    responses
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # Tests require encrypted secrets, see
    # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
    "test/extras/simple_select1.py"
    "test/integ"
    # error getting schema from stream, error code: 0, error info: Expected to
    # be able to read 19504 bytes for message body but got 19503
    "test/unit/test_connection.py"
    "test/unit/test_cursor.py"
    "test/unit/test_error_arrow_stream.py"
    "test/unit/test_ocsp.py"
    "test/unit/test_retry_network.py"
    "test/unit/test_s3_util.py"
    # AssertionError: /build/source/.wiremock/wiremock-standalone.jar does not exist
    "test/unit/test_programmatic_access_token.py"
    "test/unit/test_oauth_token.py"
    "test/unit/test_proxies.py"
    "test/unit/aio/test_programmatic_access_token_async.py"
    "test/unit/aio/test_oauth_token_async.py"
    "test/unit/aio/test_proxies_async.py"
    # aio tests that connect to the internet
    "test/unit/aio/test_connection_async_unit.py::test_invalid_backoff_policy"
    "test/unit/aio/test_ocsp.py"
    "test/unit/aio/test_s3_util_async.py::test_download_retry_exceeded_error"
    "test/unit/aio/test_s3_util_async.py::test_accelerate_in_china_endpoint"
    "test/unit/aio/test_s3_util_async.py::test_get_header_expiry_error"
    "test/unit/aio/test_s3_util_async.py::test_upload_expiry_error"
    "test/unit/aio/test_s3_util_async.py::test_download_expiry_error"
    # snowflake.connector.errors.ProgrammingError: 251008: 251008: Failed to load private key:
    # argument 'password': Cannot convert "<class 'int'>" instance to a buffer.
    "test/unit/aio/test_auth_keypair_async.py::test_auth_keypair"
  ];

  disabledTests = [
    # Tests connect to the internet
    "test_status_when_num_of_chunks_is_zero"
    "test_test_socket_get_cert"
    # Missing .wiremock/wiremock-standalone.jar
    "test_wiremock"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.connector"
  ];

  meta = {
    description = "Snowflake Connector for Python";
    homepage = "https://github.com/snowflakedb/snowflake-connector-python";
    changelog = "https://github.com/snowflakedb/snowflake-connector-python/blob/${src.tag}/DESCRIPTION.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
