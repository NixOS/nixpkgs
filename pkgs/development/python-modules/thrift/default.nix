{
  lib,
  buildPythonPackage,
  distutils,
  fetchPypi,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "thrift";
  version = "0.22.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QugnavvV9U/h02SFi2h3vF5aSl7Wn2oAW5TKSRj+FGY=";
  };

  build-system = [
    distutils
    setuptools
  ];

  dependencies = [ six ];

  # No tests. Breaks when not disabling.
  doCheck = false;

  pythonImportsCheck = [ "thrift" ];

  meta = {
    description = "Python bindings for the Apache Thrift RPC system";
    homepage = "https://thrift.apache.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hbunke ];
  };
}
