{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, voluptuous
}:

buildPythonPackage rec {
  pname = "simplisafe-python";
  version = "10.0.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-VF8R+dty54GuWvYs/OqWhfGtOVieuxtfndQUxHhu5lc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    pytz
    voluptuous
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "simplipy" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Python library the SimpliSafe API";
    homepage = "https://simplisafe-python.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
