{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  cython_0,
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
  version = "2.4.8";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sk2VplAJwkR+C0nNoEOsU/7PTwnjWNh6V0RkWPkbipE=";
  };

  nativeBuildInputs = [
    cython_0
    setuptools
  ];

  propagatedBuildInputs = [ catalogue ];

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
