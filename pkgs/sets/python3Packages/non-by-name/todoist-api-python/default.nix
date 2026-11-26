{
  lib,
  annotated-types,
  buildPythonPackage,
  dataclass-wizard,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  httpx,
  respx,
}:

buildPythonPackage rec {
  pname = "todoist-api-python";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-api-python";
    tag = "v${version}";
    hash = "sha256-rZKmDnVkIFX573bcvj8F9KTALBbX1y+E9NZHwKoGjDk=";
  };

  build-system = [ hatchling ];

  dependencies = [
    annotated-types
    httpx
    dataclass-wizard
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "todoist_api_python" ];

  meta = {
    description = "Library for the Todoist REST API";
    homepage = "https://github.com/Doist/todoist-api-python";
    changelog = "https://github.com/Doist/todoist-api-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
