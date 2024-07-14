{
  lib,
  asn1crypto,
  buildPythonPackage,
  certifi,
  cffi,
  charset-normalizer,
  cython,
  fetchPypi,
  filelock,
  idna,
  keyring,
  oscrypto,
  packaging,
  pandas,
  platformdirs,
  pyarrow,
  pycryptodomex,
  pyjwt,
  pyopenssl,
  pythonOlder,
  pytz,
  requests,
  setuptools,
  sortedcontainers,
  tomlkit,
  typing-extensions,
  wheel,
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "3.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "snowflake_connector_python";
    inherit version;
    hash = "sha256-MWnAFKA+X1hVESYF45OJelUuVYlTxp8loC4zsZmIZNA=";
  };

  build-system = [
    cython
    setuptools
    wheel
  ];


  dependencies = [
    asn1crypto
    certifi
    cffi
    charset-normalizer
    filelock
    idna
    oscrypto
    packaging
    platformdirs
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
    requests
    sortedcontainers
    tomlkit
    typing-extensions
  ];

  passthru.optional-dependencies = {
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
    maintainers = with maintainers; [ ];
  };
}
