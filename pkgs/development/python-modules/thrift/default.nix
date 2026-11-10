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
  version = "0.24.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nvYBxJ6YhHX/DnQdjhtF/uwjtIUU5SQ0HvwnQZHxeJw=";
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
