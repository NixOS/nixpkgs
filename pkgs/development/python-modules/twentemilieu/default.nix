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
  version = "0.4.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-twentemilieu";
    rev = "v${version}";
    sha256 = "1lf31ldbrsmxhbrcg284pwpvjfmwnssv3gqwd5vm2hvd9lwqn6ii";
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
