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
  version = "0.17.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "abmantis";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "0b7bqg4h9q9rk3hv2im903xn7jgfyf36kcv31v96ap75yrvip6wa";
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

  pythonImportsCheck = [ "whirlpool" ];

  meta = with lib; {
    description = "Python library for Whirlpool 6th Sense appliances";
    homepage = "https://github.com/abmantis/whirlpool-sixth-sense/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
