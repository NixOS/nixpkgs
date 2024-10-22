{
  lib,
  buildPythonPackage,
  distutils,
  fetchPypi,
  pythonOlder,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TdZi6t9riuvopBcpUnvWmt9s6qKoaBy+9k0Sc7Po/ro=";
  };

  build-system = [
    distutils
    setuptools
  ];

  dependencies = [ six ];

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
