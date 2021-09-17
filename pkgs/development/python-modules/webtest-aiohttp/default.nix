{ buildPythonPackage, fetchFromGitHub, lib, isPy27, webtest, invoke, flake8
, aiohttp, pytest-aiohttp, pytestCheckHook }:

buildPythonPackage rec {
  pname = "webtest-aiohttp";
  version = "2.0.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "sloria";
    repo = pname;
    rev = version;
    sha256 = "1apr1x0wmnc6l8wv67z4dp00fiiygda6rwpxlspfk7nk9zz37q2j";
  };

  pythonImportsCheck = [
    "webtest_aiohttp"
  ];

  propagatedBuildInputs = [ webtest ];
  checkInputs = [ invoke flake8 aiohttp pytest-aiohttp pytestCheckHook ];

  meta = with lib; {
    description = "Provides integration of WebTest with aiohttp.web applications";
    homepage = "https://github.com/sloria/webtest-aiohttp";
    license = licenses.mit;
    maintainers = with maintainers; [ cript0nauta ];
  };
}
