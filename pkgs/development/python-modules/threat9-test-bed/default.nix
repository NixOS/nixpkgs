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
  pythonAtLeast,
  pythonOlder,
  requests,
  setuptools-scm,
  standard-telnetlib,
}:

buildPythonPackage rec {
  pname = "threat9-test-bed";
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "threat9";
    repo = "threat9-test-bed";
    rev = "v${version}";
    hash = "sha256-0YSjMf2gDdrvkDaT77iwfCkiDDXKHnZyI8d7JmBSuCg=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    click
    faker
    flask
    gunicorn
    pyopenssl
    requests
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [ standard-telnetlib ];

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
    homepage = "https://github.com/threat9/threat9-test-bed";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "test-bed";
  };
}
