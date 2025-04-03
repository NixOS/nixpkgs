{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  cython,
  catalogue,
  mock,
  numpy,
  psutil,
  pytest,
  ruamel-yaml,
  setuptools,
  tornado,
}:

buildPythonPackage rec {
  pname = "srsly";
  version = "2.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qxtL9s8+Kdoj2uBJPdFRf7eHB1IGUSNRQhuJtPwnx34=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [ catalogue ];

  nativeCheckInputs = [
    mock
    numpy
    psutil
    pytest
    ruamel-yaml
    tornado
  ];

  pythonImportsCheck = [ "srsly" ];

  meta = with lib; {
    changelog = "https://github.com/explosion/srsly/releases/tag/v${version}";
    description = "Modern high-performance serialization utilities for Python";
    homepage = "https://github.com/explosion/srsly";
    license = licenses.mit;
  };
}
