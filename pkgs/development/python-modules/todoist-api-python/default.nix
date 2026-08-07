{
  lib,
  annotated-types,
  buildPythonPackage,
  dataclass-wizard,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "todoist-api-python";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-api-python";
    tag = "v${version}";
    hash = "sha256-udYFWTrWW2G6JBKQUkiqKpyBz1D4dwq7Pix6bzuWnDY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    annotated-types
    dataclass-wizard
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    responses
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
