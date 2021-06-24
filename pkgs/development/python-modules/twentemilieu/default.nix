{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, aiohttp
, yarl
, aresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "twentemilieu";
  version = "0.3.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-twentemilieu";
    rev = "v${version}";
    sha256 = "1ff35sh73m2s7fh4d8p2pjwdbfljswr8b8lpcjybz8nsh0286xph";
  };

  propagatedBuildInputs = [
    aiohttp
    yarl
  ];

  checkInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "twentemilieu" ];

  meta = with lib; {
    description = "Python client for Twente Milieu";
    homepage = "https://github.com/frenck/python-twentemilieu";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
