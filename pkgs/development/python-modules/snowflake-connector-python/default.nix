{ lib
, asn1crypto
, buildPythonPackage
, certifi
, cffi
, charset-normalizer
, fetchPypi
, filelock
, idna
, oscrypto
, pycryptodomex
, pyjwt
, pyopenssl
, pythonOlder
, pytz
, requests
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "2.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dVGyQEsmhQ+xLGIy0BW6XRCtsTsJHjef6Lg2ZJL2JLg=";
  };

  propagatedBuildInputs = [
    asn1crypto
    certifi
    cffi
    charset-normalizer
    filelock
    idna
    oscrypto
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
    requests
    setuptools
    typing-extensions
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pyOpenSSL>=16.2.0,<23.0.0" "pyOpenSSL" \
      --replace "charset-normalizer~=2.0.0" "charset_normalizer>=2"
  '';

  # Tests require encrypted secrets, see
  # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.connector"
  ];

  meta = with lib; {
    changelog = "https://github.com/snowflakedb/snowflake-connector-python/blob/v${version}/DESCRIPTION.md";
    description = "Snowflake Connector for Python";
    homepage = "https://github.com/snowflakedb/snowflake-connector-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
