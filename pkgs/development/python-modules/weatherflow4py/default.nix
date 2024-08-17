{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  marshmallow,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  websockets,
}:

buildPythonPackage rec {
  pname = "weatherflow4py";
  version = "0.2.23";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "weatherflow4py";
    rev = "refs/tags/v${version}";
    hash = "sha256-ghdjQyZPLFzgmrB2ppzNbqM/D2/zW872tw4emzInLBY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    dataclasses-json
    marshmallow
    websockets
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "weatherflow4py" ];

  meta = with lib; {
    description = "Module to interact with the WeatherFlow REST API";
    homepage = "https://github.com/jeeftor/weatherflow4py";
    changelog = "https://github.com/jeeftor/weatherflow4py/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
