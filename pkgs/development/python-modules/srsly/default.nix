{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cython
, catalogue
, mock
, numpy
, psutil
, pytest
, ruamel-yaml
, setuptools
, tornado
}:

buildPythonPackage rec {
  pname = "srsly";
  version = "2.4.7";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k8LMRYh3gmHMsj3QVDsk3tgQFd2KtOwTfNfQSWUDXQg=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [
    catalogue
  ];

  nativeCheckInputs = [
    mock
    numpy
    psutil
    pytest
    ruamel-yaml
    tornado
  ];

  pythonImportsCheck = [
    "srsly"
  ];

  meta = with lib; {
    changelog = "https://github.com/explosion/srsly/releases/tag/v${version}";
    description = "Modern high-performance serialization utilities for Python";
    homepage = "https://github.com/explosion/srsly";
    license = licenses.mit;
  };
}
