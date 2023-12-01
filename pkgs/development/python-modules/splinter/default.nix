{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, setuptools
, urllib3
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
  version = "0.20.1";

  disabled = isPy27;

  pyproject = true;

  src = fetchFromGitHub {
    owner = "cobrateam";
    repo = "splinter";
    rev = "refs/tags/${version}";
    hash = "sha256-6oHcHIkqOr0aFNfCNjZpm4zIYuz2ov9drfCxSdjAg7o=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    urllib3
  ];

  passthru.optional-dependencies = {
    "zope.testbrowser" = [ zope-testbrowser lxml cssselect ];
    django = [ django lxml cssselect ];
    flask = [ flask lxml cssselect ];
    selenium = [ selenium ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTests = [
    # driver is present and fails with a different error during loading
    "test_browser_local_driver_not_present"
    "test_browser_log_missing_drivers"
    "test_local_driver_not_present"
  ];

  disabledTestPaths = [
    "samples"
    # We run neither Chromium nor Firefox nor ...
    "tests/test_async_finder.py"
    "tests/test_element_is_visible.py"
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
