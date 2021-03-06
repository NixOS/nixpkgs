{ buildPythonPackage
, isPy27
, asn1crypto
, azure-storage-blob
, boto3
, certifi
, cffi
, fetchPypi
, future
, idna
, ijson
, isPy3k
, lib
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
  version = "2.3.10";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad62bfd31e677d39984449d9c68e233da2776b80894a988a2421aad412e4c44f";
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
  ] ++ lib.optionals (!isPy3k) [
    pyarrow
    pyasn1-modules
    urllib3
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pyOpenSSL>=16.2.0,<20.0.0'," "'pyOpenSSL',"
  '';

  # tests require encrypted secrets, see
  # https://github.com/snowflakedb/snowflake-connector-python/tree/master/.github/workflows/parameters
  doCheck = false;
  pythonImportsCheck = [ "snowflake" "snowflake.connector" ];

  meta = with lib; {
    description = "Snowflake Connector for Python";
    homepage = "https://www.snowflake.com/";
    license = licenses.asl20;
  };
}
