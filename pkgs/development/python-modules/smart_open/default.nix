{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, boto
, boto3
, bz2file
, mock
, moto
, requests
, responses
}:

buildPythonPackage rec {
  pname = "smart_open";
  version = "4.2.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d9f5a0f173ccb9bbae528db5a3804f57145815774f77ef755b9b0f3b4b2a9dcb";
  };

  # moto>=1.0.0 is backwards-incompatible and some tests fail with it,
  # so disable tests for now
  doCheck = false;

  checkInputs = [ mock moto responses ];

  # upstream code requires both boto and boto3
  propagatedBuildInputs = [ boto boto3 bz2file requests ];
  meta = {
    license = lib.licenses.mit;
    description = "smart_open is a Python 2 & Python 3 library for efficient streaming of very large file";
    maintainers = with lib.maintainers; [ jyp ];
  };
}
