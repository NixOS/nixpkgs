{ lib
, buildPythonPackage
, pythonOlder
, asn1crypto
, azure-storage-blob
, boto3
, certifi
, cffi
, fetchPypi
, future
, idna
, ijson
, oscrypto
, pyarrow
, pyasn1-modules
, pycryptodomex
, pyjwt
, pyopenssl
, pytz
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "2.7.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf8624539b18f5752756b3029622c08e9113f6a861a9f4689133d483a0ffd73b";
  };

  propagatedBuildInputs = [
    azure-storage-blob
    asn1crypto
    boto3
    certifi
    cffi
    future
    idna
    ijson
    oscrypto
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
    requests
    six
    pyarrow
    pyasn1-modules
    urllib3
  ];

  # Tests require encrypted secrets, see
  # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
  doCheck = false;

  pythonImportsCheck = [
    "snowflake"
    "snowflake.connector"
  ];

  meta = with lib; {
    description = "Snowflake Connector for Python";
    homepage = "https://www.snowflake.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
