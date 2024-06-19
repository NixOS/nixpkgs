{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # optional-dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sFQXtYve8jbCDnEfsv7hjk23NIqS7c7AExizKqs0kl4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies.arrays = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.arrays;

  pythonImportsCheck = [ "uncertainties" ];

  meta = with lib; {
    homepage = "https://pythonhosted.org/uncertainties/";
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
