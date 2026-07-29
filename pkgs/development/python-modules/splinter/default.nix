{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  urllib3,
  selenium,
  cssselect,
  django,
  flask,
  lxml,
  pytestCheckHook,
  zope-testbrowser,
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cobrateam";
    repo = "splinter";
    tag = version;
    hash = "sha256-PGGql8yI1YosoUBAyDoI/8k7s4sVYnXEV7eow3GHH88=";
  };

  patches = [
    ./lxml-6.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ urllib3 ];

  optional-dependencies = {
    "zope.testbrowser" = [
      zope-testbrowser
      lxml
      cssselect
    ];
    django = [
      django
      lxml
      cssselect
    ];
    flask = [
      flask
      lxml
      cssselect
    ];
    selenium = [ selenium ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

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

  meta = {
    changelog = "https://splinter.readthedocs.io/en/latest/news.html";
    description = "Browser abstraction for web acceptance testing";
    homepage = "https://github.com/cobrateam/splinter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
