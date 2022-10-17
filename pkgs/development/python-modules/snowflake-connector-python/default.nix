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
  version = "2.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gvZ+Nuf+Ns1XIYpsBHdegzA9sjFxT9+Qm6kbsJR8JLY=";
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
      --replace "cryptography>=3.1.0,<37.0.0" "cryptography" \
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
    description = "Snowflake Connector for Python";
    homepage = "https://github.com/snowflakedb/snowflake-connector-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
