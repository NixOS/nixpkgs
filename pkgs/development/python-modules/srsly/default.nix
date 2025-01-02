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
  version = "2.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J3Z1LNsUJ1ygHpp7epwEfM8x2xfwB25zNDz8yajfbL0=";
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
