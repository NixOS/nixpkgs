{
  lib,
  buildPythonPackage,
  boto3,
  fetchFromGitHub,
  httpretty,
  keyring,
  lz4,
  pytestCheckHook,
  python-dateutil,
  pytz,
  requests-gssapi,
  requests-kerberos,
  requests,
  setuptools,
  sqlalchemy,
  testcontainers,
  tzlocal,
  zstandard,
}:

buildPythonPackage rec {
  pname = "trino-python-client";
  version = "0.334.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "trino-python-client";
    owner = "trinodb";
    tag = version;
    hash = "sha256-cSwMmzIUFYX8VgSwobth8EsARUff3hhfBf+IrhuFSYM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lz4
    python-dateutil
    pytz
    requests
    tzlocal
    zstandard
  ];

  optional-dependencies = lib.fix (self: {
    kerberos = [ requests-kerberos ];
    gsaapi = [ requests-gssapi ];
    sqlalchemy = [ sqlalchemy ];
    external-authentication-token-cache = [ keyring ];
    all = self.kerberos ++ self.sqlalchemy;
  });

  nativeCheckInputs = [
    boto3
    httpretty
    pytestCheckHook
    testcontainers
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "trino" ];

  disabledTestPaths = [
    # Tests require a running trino instance
    "tests/integration/test_types_integration.py"
    "tests/integration/test_dbapi_integration.py"
    "tests/integration/test_sqlalchemy_integration.py"
  ];

  disabledTestMarks = [ "auth" ];

  disabledTests = [
    # Tests require a running trino instance
    "test_oauth2"
    "test_token_retrieved_once_when_authentication_instance_is_shared"
    "test_multithreaded_oauth2_authentication_flow"
  ];

  meta = with lib; {
    changelog = "https://github.com/trinodb/trino-python-client/blob/${src.tag}/CHANGES.md";
    description = "Client for the Trino distributed SQL Engine";
    homepage = "https://github.com/trinodb/trino-python-client";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cpcloud
      flokli
    ];
  };
}
