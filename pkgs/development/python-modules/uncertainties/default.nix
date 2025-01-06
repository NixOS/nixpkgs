{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "uncertainties";
    tag = version;
    hash = "sha256-cm0FeJCxyBLN0GCKPnscBCx9p9qCDQdwRfhBRgQIhAo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies.arrays = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ optional-dependencies.arrays;

  pythonImportsCheck = [ "uncertainties" ];

  meta = {
    homepage = "https://pythonhosted.org/uncertainties/";
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with lib.maintainers; [ rnhmjoj ];
    license = lib.licenses.bsd3;
  };
}
