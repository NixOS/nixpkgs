{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, selenium
, cssselect
, django
, flask
, lxml
, pytestCheckHook
, zope-testbrowser
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.18.0";

  disabled = isPy27;

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "cobrateam";
    repo = "splinter";
    rev = version;
    hash = "sha256-kJ5S/fBesaxTbxCQ0yBR30+CfCV6U5jgbfDZA7eF6ac=";
  };

  propagatedBuildInputs = [
    selenium
  ];

  checkInputs = [
    cssselect
    django
    flask
    lxml
    pytestCheckHook
    zope-testbrowser
  ];

  disabledTests = [
    # driver is present and fails with a different error during loading
    "test_browser_local_driver_not_present"
    "test_local_driver_not_present"
  ];

  disabledTestPaths = [
    "samples"
    # We run neither Chromium nor Firefox nor ...
    "tests/test_async_finder.py"
    "tests/test_html_snapshot.py"
    "tests/test_iframes.py"
    "tests/test_mouse_interaction.py"
    "tests/test_popups.py"
    "tests/test_screenshot.py"
    "tests/test_shadow_root.py"
    "tests/test_webdriver.py"
    "tests/test_webdriver_chrome.py"
    "tests/test_webdriver_edge_chromium.py"
    "tests/test_webdriver_firefox.py"
    "tests/test_webdriver_remote.py"
  ];

  pythonImportsCheck = [ "splinter" ];

  meta = with lib; {
    description = "Browser abstraction for web acceptance testing";
    homepage = "https://github.com/cobrateam/splinter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
