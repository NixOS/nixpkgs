{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, responses
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "testrail-api";
  version = "1.12.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tolstislon";
    repo = "testrail-api";
    rev = "refs/tags/${version}";
    hash = "sha256-lIlTrAdNtBJdwiSFwpcHA2e+fRC+MbHS0PX7prAN+RY=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "testrail_api"
  ];

  meta = with lib; {
    description = "A Python wrapper of the TestRail API";
    homepage = "https://github.com/tolstislon/testrail-api";
    changelog = "https://github.com/tolstislon/ytestrail-api/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ aanderse ];
  };
}
