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
  version = "2.3.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a072ee61ef156e5938e04447f0b99248b87ef262e498b5e5002f5b579cd7fb2";
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
      --replace "'boto3>=1.4.4,<1.15'," "'boto3~=1.15'," \
      --replace "'cryptography>=2.5.0,<3.0.0'," "'cryptography'," \
      --replace "'idna<2.10'," "'idna'," \
      --replace "'requests<2.24.0'," "'requests',"
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
