{ buildPythonPackage
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
, pyarrow
, pyasn1-modules
, pycryptodomex
, pyjwt
, pyopenssl
, pytz
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "snowflake-connector-python";
  version = "1.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ll1brxs933za18hcsc3lrykk9x9yczyv3qs13zv3ql60pxfdmcn";
  };

  propagatedBuildInputs = [
    azure-storage-blob
    boto3
    certifi
    cffi
    future
    idna
    ijson
    pycryptodomex
    pyjwt
    pyopenssl
    pytz
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
