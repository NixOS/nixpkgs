{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pmdarima,
  scikit-learn,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tbats";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intive-DataScience";
    repo = "tbats";
    rev = version;
    hash = "sha256-f6QqDq/ffbnFBZRAT6KQRlqvZZSE+Pff2/o+htVabZI=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    pmdarima
    scikit-learn
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    # test_R folder is just for comparison of results with R lib
    # we need only test folder
    "test/"
  ];

  # several tests has same name, so we use --deselect instead of disableTests
  dilsabledTestPaths = [
    # Test execution is too long > 15 min
    "test/tbats/TBATS_test.py::TestTBATS::test_fit_predict_trigonometric_seasonal"
  ];

  pythonImportsCheck = [ "tbats" ];

  meta = with lib; {
    description = "BATS and TBATS forecasting methods";
    homepage = "https://github.com/intive-DataScience/tbats";
    changelog = "https://github.com/intive-DataScience/tbats/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
