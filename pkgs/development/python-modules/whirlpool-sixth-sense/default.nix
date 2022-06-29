{ lib
, aioconsole
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "whirlpool-sixth-sense";
  version = "0.16";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = pname;
    rev = version;
    hash = "sha256-sggvqa04r/7GK3glHfY0jxsRR2t7qTSg8gfyhoK7YiU=";
  };

  propagatedBuildInputs = [
    aioconsole
    aiohttp
    websockets
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "whirlpool"
  ];

  meta = with lib; {
    description = "Library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
