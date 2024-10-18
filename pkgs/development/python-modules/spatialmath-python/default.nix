{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  oldest-supported-numpy,
  setuptools,
  ansitable,
  matplotlib,
  numpy,
  scipy,
  typing-extensions,
  coverage,
  flake8,
  pytest,
  pytest-timeout,
  pytest-xvfb,
  sympy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "spatialmath-python";
  version = "1.1.11";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "spatialmath_python";
    inherit version;
    hash = "sha256-9EUlDGkpV/a73XWvrbtZLK8wrR8Am5EOkv3iSf9J4rM=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
  ];

  pythonRemoveDeps = [ "pre-commit" ];

  propagatedBuildInputs = [
    ansitable
    matplotlib
    numpy
    scipy
    typing-extensions
  ];

  optional-dependencies = {
    dev = [
      coverage
      flake8
      pytest
      pytest-timeout
      pytest-xvfb
      sympy
    ];
  };

  pythonImportsCheck = [ "spatialmath" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Provides spatial maths capability for Python";
    homepage = "https://pypi.org/project/spatialmath-python/";
    license = licenses.mit;
    maintainers = with maintainers; [
      djacu
      a-camarillo
    ];
  };
}
