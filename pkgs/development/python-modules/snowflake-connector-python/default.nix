{
  lib,
  asn1crypto,
  azure-identity,
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
  version = "4.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    tag = "v${version}";
    hash = "sha256-Jz2HzSwio1RNx5Fl7QX+1AQ43DYsnLZHnC8BJTreLiU=";
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
    azure = [ azure-identity ];
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
    numpy
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
    "test/wif"
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
    "test/unit/test_redirect_retry.py"
    "test/unit/test_auth_jwt_error_codes.py"
    "test/unit/test_result_batch.py::test_qrmk_branch_does_not_log_qrmk_value_e2e"
    # asyncio support is in preview upstream and its tests break frequently
    "test/unit/aio"
  ];

  disabledTests = [
    # Tests connect to the internet
    "test_status_when_num_of_chunks_is_zero"
    "test_test_socket_get_cert"
    "test_get_digest_does_not_compute_md5"
    "test_compute_content_md5_is_noop_by_default"
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
    maintainers = with lib.maintainers; [
      sarahec
      vtimofeenko
    ];
  };
}
