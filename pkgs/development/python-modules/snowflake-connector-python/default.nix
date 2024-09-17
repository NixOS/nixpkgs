{
  lib,
  asn1crypto,
  buildPythonPackage,
  certifi,
  cffi,
  charset-normalizer,
  cryptography,
  cython,
  fetchPypi,
  filelock,
  idna,
  keyring,
  packaging,
  pandas,
  platformdirs,
  pyarrow,
  pyjwt,
  pyopenssl,
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
  version = "3.12.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "snowflake_connector_python";
    inherit version;
    hash = "sha256-/ZvCqxv1OE0si2W8ALsEdVV9UvBHenESkzSqtT+Wef0=";
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

  # Tests require encrypted secrets, see
  # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
  doCheck = false;

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
