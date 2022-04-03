{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K1tkiPze0h+dMSqiPJ/2oBldD2ribdvVrZ4+Jd/BRAg=";
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
