{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, backoff
, packaging
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "wled";
  version = "0.4.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-wled";
    rev = "v${version}";
    sha256 = "1adh23v4c9kia3ddqdq0brksd5rhgh4ff7l5hil8klx4dmkrjfz3";
  };

  propagatedBuildInputs = [
    aiohttp
    backoff
    packaging
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "wled" ];

  meta = with lib; {
    description = "Asynchronous Python client for WLED";
    homepage = "https://github.com/frenck/python-wled";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
