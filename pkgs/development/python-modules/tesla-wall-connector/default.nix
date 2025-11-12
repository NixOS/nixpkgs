{
  lib,
  aiohttp,
  aresponses,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "tesla-wall-connector";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "einarhauks";
    repo = "tesla-wall-connector";
    rev = version;
    hash = "sha256-3jj3LU0xRIC6U5DmitkTNjejvSZJWguTS/TeotOD8oc=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    aiohttp
    backoff
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tesla_wall_connector" ];

  meta = with lib; {
    description = "Library for communicating with a Tesla Wall Connector";
    homepage = "https://github.com/einarhauks/tesla-wall-connector";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
