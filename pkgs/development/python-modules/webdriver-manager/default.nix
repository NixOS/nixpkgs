{
  buildPythonPackage,
  fetchPypi,
  lib,
  requests,
  python-dotenv,
  tqdm,
  packaging,
  pytestCheckHook,
  selenium,
}:

buildPythonPackage rec {
  pname = "webdriver-manager";
  version = "3.8.6";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "webdriver_manager";
    hash = "sha256-7niNOJuPRSIqimL285tXk2Ch+Hvkba1tqJkYNUrzznM=";
  };

  propagatedBuildInputs = [
    requests
    python-dotenv
    tqdm
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    selenium
  ];

  # Disabling these tests since they require network
  disabledTests = [
    "test_custom_http_client"
    "test_silent_global_logs"
    "test_cuncurent_1"
    "test_cuncurent_2"
    "test_brave_driver"
    "test_chrome_driver"
    "test_chromium_driver"
    "test_downloader"
    "test_edge_driver"
    "test_firefox_manager"
    "test_ie_driver"
    "test_opera_manager"
  ];

  meta = {
    changelog = "https://github.com/SergeyPirogov/webdriver_manager/blob/${version}/CHANGELOG.md";
    description = "A Python library that simplifies management of binary drivers for browsers";
    homepage = "https://github.com/SergeyPirogov/webdriver_manager";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.drupol ];
  };
}
