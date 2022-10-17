{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, webtest
}:

buildPythonPackage rec {
  pname = "webtest-aiohttp";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sloria";
    repo = pname;
    rev = version;
    sha256 = "sha256-UuAz/k/Tnumupv3ybFR7PkYHwG3kH7M5oobZykEP+ao=";
  };

  propagatedBuildInputs = [
    webtest
  ];

  checkInputs = [
    aiohttp
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "webtest_aiohttp"
  ];

  meta = with lib; {
    description = "Provides integration of WebTest with aiohttp.web applications";
    homepage = "https://github.com/sloria/webtest-aiohttp";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
