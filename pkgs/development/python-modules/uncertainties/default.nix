{
  lib,
  buildPythonPackage,
  setuptools-scm,
  fetchFromGitHub,
  pytestCheckHook,
  numpy,
}:

buildPythonPackage rec {
  pname = "uncertainties";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmfit";
    repo = "uncertainties";
    rev = "refs/tags/${version}";
    hash = "sha256-AaFazHeq7t4DnG2s9GvmAJ3ni62PWHR//mNPL+WyGSI=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    numpy
  ];

  meta = with lib; {
    homepage = "https://pythonhosted.org/uncertainties/";
    description = "Transparent calculations with uncertainties on the quantities involved (aka error propagation)";
    maintainers = with maintainers; [ rnhmjoj ];
    license = licenses.bsd3;
  };
}
