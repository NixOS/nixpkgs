{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, dataclasses-json
, fetchFromGitHub
, marshmallow
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, websockets
}:

buildPythonPackage rec {
  pname = "weatherflow4py";
  version = "0.2.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "weatherflow4py";
    rev = "refs/tags/v${version}";
    hash = "sha256-RmDOu0KrdVvjhezpcN4sWG0DXA4O3Jg//vtNbDK1HjU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "weatherflow4py"
  ];

  meta = with lib; {
    description = "Module to interact with the WeatherFlow REST API";
    homepage = "https://github.com/jeeftor/weatherflow4py";
    changelog = "https://github.com/jeeftor/weatherflow4py/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
