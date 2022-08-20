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
  version = "2.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-WVyMYmuezTS3GNcIY9Uh+/0+lcgdmoLL6o5d1SFMfvE=";
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
