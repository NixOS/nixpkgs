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
  version = "2.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d3qxjqc79fi2l4sns5svbc6kfaihivsrpycflmh50h7x0k9sv7f";
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

  # tests are not working
  # XXX: fix the tests
  doCheck = false;

  meta = with lib; {
    description = "Snowflake Connector for Python";
    homepage = "https://www.snowflake.com/";
    license = licenses.asl20;
  };
}
