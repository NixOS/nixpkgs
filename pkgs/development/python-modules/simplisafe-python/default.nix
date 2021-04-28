{ lib
, aiohttp
, aresponses
, asynctest
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytest-asyncio
, pytest-cov
, pytestCheckHook
, python-engineio
, python-socketio
, pythonOlder
, pytz
, voluptuous
, websockets
}:

buildPythonPackage rec {
  pname = "simplisafe-python";
  version = "9.6.9";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = pname;
    rev = version;
    sha256 = "1q5w5pvrgj94bzd5wig79l4hipkfrcdah54rvwyi7b8q46gw77sg";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    python-engineio
    python-socketio
    pytz
    voluptuous
    websockets
  ];

  checkInputs = [
    aresponses
    asynctest
    pytest-asyncio
    pytest-cov
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "simplipy" ];

  meta = with lib; {
    description = "Python library the SimpliSafe API";
    homepage = "https://simplisafe-python.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
