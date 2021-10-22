{ lib
, aiohttp
, aresponses
, asynctest
, backoff
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, pytz
, types-pytz
, voluptuous
, websockets
}:

buildPythonPackage rec {
  pname = "simplisafe-python";
  version = "12.0.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "sha256-/KnDsnx+Jrirj6uBkdao6PI2jhtzKqDK6cmmQgsO5T4=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    backoff
    pytz
    types-pytz
    voluptuous
    websockets
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # simplipy/api.py:253: InvalidCredentialsError
    "test_request_error_failed_retry"
    "test_update_error"
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
