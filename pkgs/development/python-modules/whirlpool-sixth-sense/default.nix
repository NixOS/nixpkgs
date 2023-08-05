{ lib
, aioconsole
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, setuptools
, websockets
}:

buildPythonPackage rec {
  pname = "whirlpool-sixth-sense";
  version = "0.18.4";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9dwkylr+aCTGw/VIY90nxq8IkqBASeEfdr5JGz7pZrc=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aioconsole
    aiohttp
    websockets
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  # https://github.com/abmantis/whirlpool-sixth-sense/issues/15
  doCheck = false;

  pythonImportsCheck = [ "whirlpool" ];

  meta = with lib; {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
