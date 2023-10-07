{ lib
, aiohttp
, authcaptureproxy
, backoff
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, httpx
, orjson
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, tenacity
, wrapt
}:

buildPythonPackage rec {
  pname = "teslajsonpy";
  version = "3.9.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QqC/vPPl9R1n4rtiR+t1oy4V+bPr1QgAwIgpuxiwxj8=";
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
    orjson
    tenacity
    wrapt
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "teslajsonpy"
  ];

  meta = with lib; {
    description = "Python library to work with Tesla API";
    homepage = "https://github.com/zabuldon/teslajsonpy";
    changelog = "https://github.com/zabuldon/teslajsonpy/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
