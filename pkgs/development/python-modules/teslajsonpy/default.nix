{ lib
, aiohttp
, authcaptureproxy
, backoff
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, httpx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, wrapt
}:

buildPythonPackage rec {
  pname = "teslajsonpy";
  version = "1.2.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "v${version}";
    sha256 = "05zn923zsr3jdilhj7bl16sabxy3ziwwlz30jq1xappbf824f9sa";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    authcaptureproxy
    aiohttp
    backoff
    beautifulsoup4
    httpx
    wrapt
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "teslajsonpy" ];

  meta = with lib; {
    description = "Python library to work with Tesla API";
    homepage = "https://github.com/zabuldon/teslajsonpy";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
