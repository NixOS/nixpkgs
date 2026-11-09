{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  pybrowsers,
  pytest-cov-stub,
  pytestCheckHook,
  python-dotenv,
  requests,
  selenium,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "webdriver-manager";
  version = "4.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SergeyPirogov";
    repo = "webdriver_manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UQeiBtql0+IEG0iY0XoY+iqKqMB9Wmt+NxH7coxrJCw=";
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
    pytest-cov-stub
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

  meta = {
    description = "Module to manage the binary drivers for different browsers";
    homepage = "https://github.com/SergeyPirogov/webdriver_manager/";
    changelog = "https://github.com/SergeyPirogov/webdriver_manager/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
})
