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
  pythonRelaxDepsHook,
}:

buildPythonPackage rec {
  pname = "spatialmath-python";
  version = "1.1.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "spatialmath_python";
    inherit version;
    hash = "sha256-7h29RHCrxdexpabtxMQx/7RahQmCDGHhdJ1WETvtfYg=";
  };

  nativeBuildInputs = [
    oldest-supported-numpy
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [ "pre-commit" ];

  propagatedBuildInputs = [
    ansitable
    matplotlib
    numpy
    scipy
    typing-extensions
  ];

  passthru.optional-dependencies = {
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
