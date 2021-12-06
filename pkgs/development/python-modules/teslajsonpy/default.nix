{ lib
, aiohttp
, authcaptureproxy
, backoff
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, wrapt
}:

buildPythonPackage rec {
  pname = "teslajsonpy";
  version = "1.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "v${version}";
    sha256 = "17ld1ciylfc8kmf5iazzrlqqdf434wi5dfjzm68nm5d539gccfss";
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

  pythonImportsCheck = [
    "teslajsonpy"
  ];

  meta = with lib; {
    description = "Python library to work with Tesla API";
    homepage = "https://github.com/zabuldon/teslajsonpy";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
