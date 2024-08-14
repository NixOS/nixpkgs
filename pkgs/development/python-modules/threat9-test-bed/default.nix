{
  lib,
  buildPythonPackage,
  click,
  faker,
  fetchFromGitHub,
  flask,
  gunicorn,
  pyopenssl,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  requests,
}:

buildPythonPackage rec {
  pname = "threat9-test-bed";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "threat9";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0YSjMf2gDdrvkDaT77iwfCkiDDXKHnZyI8d7JmBSuCg=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    click
    faker
    flask
    gunicorn
    pyopenssl
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "threat9_test_bed" ];

  disabledTests = [
    # Assertion issue with the response codes
    "test_http_service_mock"
    "tests_http_service_mock"
    "test_http_service_mock_random_port"
  ];

  meta = with lib; {
    description = "Module for adding unittests.mock as view functions";
    mainProgram = "test-bed";
    homepage = "https://github.com/threat9/threat9-test-bed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
