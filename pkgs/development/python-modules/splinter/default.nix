{ lib
, buildPythonPackage
, fetchFromGitHub
, selenium
, six
, flask
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "splinter";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "cobrateam";
    repo = "splinter";
    rev = version;
    hash = "sha256-7QhFz/qBh2ECyeyvjCyqOYy/YrUK7KVX13VC/gem5BQ=";
  };

  propagatedBuildInputs = [
    selenium
    six
  ];

  checkInputs = [
    flask
    pytestCheckHook
  ];

  disabledTestPaths = [
    "samples"
    "tests/test_djangoclient.py"
    "tests/test_flaskclient.py"
    "tests/test_popups.py"
    "tests/test_webdriver.py"
    "tests/test_webdriver_chrome.py"
    "tests/test_webdriver_edge_chromium.py"
    "tests/test_webdriver_firefox.py"
    "tests/test_webdriver_remote.py"
    "tests/test_zopetestbrowser.py"
  ];

  pythonImportsCheck = [ "splinter" ];

  meta = with lib; {
    description = "Browser abstraction for web acceptance testing";
    homepage = "https://github.com/cobrateam/splinter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
