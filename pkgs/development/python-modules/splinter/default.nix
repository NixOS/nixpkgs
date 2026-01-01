{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cobrateam";
    repo = "splinter";
    tag = version;
    hash = "sha256-PGGql8yI1YosoUBAyDoI/8k7s4sVYnXEV7eow3GHH88=";
  };

<<<<<<< HEAD
  patches = [
    ./lxml-6.patch
  ];

  build-system = [ setuptools ];

  dependencies = [ urllib3 ];
=======
  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ urllib3 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    changelog = "https://splinter.readthedocs.io/en/latest/news.html";
    description = "Browser abstraction for web acceptance testing";
    homepage = "https://github.com/cobrateam/splinter";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    changelog = "https://splinter.readthedocs.io/en/latest/news.html";
    description = "Browser abstraction for web acceptance testing";
    homepage = "https://github.com/cobrateam/splinter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
