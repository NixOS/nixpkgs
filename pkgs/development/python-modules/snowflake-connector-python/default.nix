{
  lib,
  asn1crypto,
  buildPythonPackage,
  certifi,
  cffi,
  charset-normalizer,
  cryptography,
  cython,
  fetchFromGitHub,
  filelock,
  idna,
  keyring,
  packaging,
  pandas,
  platformdirs,
  pyarrow,
  pyjwt,
  pyopenssl,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  pytz,
  requests,
  setuptools,
  sortedcontainers,
  tomlkit,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "3.12.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "snowflakedb";
    repo = "snowflake-connector-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-6poMWKQB/NR40W39KDJwBgYGeAHsr4f1GJhPxYiTc1k=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    asn1crypto
    certifi
    cffi
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

  optional-dependencies = {
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
    pytest-xdist
    pytestCheckHook
  ];

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
  ];

  disabledTests = [
    # Tests connect to the internet
    "test_status_when_num_of_chunks_is_zero"
    "test_test_socket_get_cert"
  ];

  pythonImportsCheck = [
    "snowflake"
    "snowflake.connector"
  ];

  meta = with lib; {
    description = "Snowflake Connector for Python";
    homepage = "https://github.com/snowflakedb/snowflake-connector-python";
    changelog = "https://github.com/snowflakedb/snowflake-connector-python/blob/v${version}/DESCRIPTION.md";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
