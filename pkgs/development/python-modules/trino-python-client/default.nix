{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build
  setuptools,
  # required
  pytz,
  requests,
  tzlocal,
  # optional
  requests-kerberos,
  sqlalchemy,
  keyring,
  # tests
  pytestCheckHook,
  httpretty,
}:

buildPythonPackage rec {
  pname = "trino-python-client";
  version = "0.322.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "trinodb";
    rev = "refs/tags/${version}";
    hash = "sha256-Hl88Keavyp1QBw67AFbevy/btzNs7UlsKQ93K02YgLM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pytz
    requests
    tzlocal
  ];

  passthru.optional-dependencies = lib.fix (self: {
    kerberos = [ requests-kerberos ];
    sqlalchemy = [ sqlalchemy ];
    external-authentication-token-cache = [ keyring ];
    all = self.kerberos ++ self.sqlalchemy;
  });

  nativeCheckInputs = [
    httpretty
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all;

  pythonImportsCheck = [ "trino" ];

  disabledTestPaths = [
    # these all require a running trino instance
    "tests/integration/test_types_integration.py"
    "tests/integration/test_dbapi_integration.py"
    "tests/integration/test_sqlalchemy_integration.py"
  ];

  pytestFlagsArray = [ "-k 'not auth'" ];

  meta = with lib; {
    changelog = "https://github.com/trinodb/trino-python-client/blob/${version}/CHANGES.md";
    description = "Client for the Trino distributed SQL Engine";
    homepage = "https://github.com/trinodb/trino-python-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
