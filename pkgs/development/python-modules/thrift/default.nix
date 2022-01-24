{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "87c8205a71cf8bbb111cb99b1f7495070fbc9cabb671669568854210da5b3e29";
  };

  propagatedBuildInputs = [ six ];

  # No tests. Breaks when not disabling.
  doCheck = false;

  pythonImportsCheck = [ "thrift" ];

  meta = with lib; {
    description = "Python bindings for the Apache Thrift RPC system";
    homepage = "https://thrift.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ hbunke ];
  };
}
