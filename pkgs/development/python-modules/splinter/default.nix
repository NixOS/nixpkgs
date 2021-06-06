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
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "cobrateam";
    repo = "splinter";
    rev = version;
    sha256 = "0480bqprv8581cvnc80ls91rz9780wvdnfw99zsw44hvy2yg15a6";
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
    "tests/test_webdriver.py"
    "tests/test_webdriver_chrome.py"
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
