{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "todoist-api-python";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = "todoist-api-python";
    tag = "v${version}";
    hash = "sha256-rdXYAPCs3PSIFfpBKMfNNRUOJJK5Y/IzY5bmhxTm4zw=";
  };

  build-system = [ poetry-core ];

  dependencies = [ requests ];

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
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
