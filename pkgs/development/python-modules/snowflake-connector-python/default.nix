{ lib
, asn1crypto
, buildPythonPackage
, certifi
, cffi
, charset-normalizer
, fetchPypi
, idna
, oscrypto
, pycryptodomex
, pyjwt
, pyopenssl
, pythonOlder
, pytz
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "2.7.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nPsHsEi8sf5kbQP3SAzLaod+nEUGcwLpC8/3/XL2vC8=";
  };

  propagatedBuildInputs = [
    asn1crypto
    certifi
    cffi
    charset-normalizer
    idna
    oscrypto
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
    requests
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pyOpenSSL>=16.2.0,<23.0.0" "pyOpenSSL" \
      --replace "cryptography>=3.1.0,<37.0.0" "cryptography"
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
