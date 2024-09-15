{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pybrowsers,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
  requests,
  selenium,
  setuptools,
}:

buildPythonPackage rec {
  pname = "webdriver-manager";
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SergeyPirogov";
    repo = "webdriver_manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZmrQa/2vPwYgSvY3ZUvilg4RizVXpu5hvJJBQVXkK8E=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    packaging
    python-dotenv
    requests
  ];

  nativeCheckInputs = [
    pybrowsers
    pytestCheckHook
    selenium
  ];

  pythonImportsCheck = [ "webdriver_manager" ];

  disabledTestPaths = [
    # Tests require network access and browsers available
    "tests_negative/"
    "tests_xdist/"
    "tests/test_brave_driver.py"
    "tests/test_chrome_driver.py"
    "tests/test_chrome_driver.py"
    "tests/test_chromium_driver.py"
    "tests/test_custom_http_client.py"
    "tests/test_downloader.py"
    "tests/test_edge_driver.py"
    "tests/test_firefox_manager.py"
    "tests/test_ie_driver.py"
    "tests/test_opera_manager.py"
    "tests/test_opera_manager.py"
    "tests/test_silent_global_logs.py"
  ];

  meta = with lib; {
    description = "Module to manage the binary drivers for different browsers";
    homepage = "https://github.com/SergeyPirogov/webdriver_manager/";
    changelog = "https://github.com/SergeyPirogov/webdriver_manager/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
