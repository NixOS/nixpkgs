{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "2.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QJK8hDxxt1lcbJCgMCoZeFjFuf5DBn9irmpFvDuqHBk=";
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

  meta = {
    changelog = "https://github.com/explosion/srsly/releases/tag/v${version}";
    description = "Modern high-performance serialization utilities for Python";
    homepage = "https://github.com/explosion/srsly";
    license = lib.licenses.mit;
  };
}
