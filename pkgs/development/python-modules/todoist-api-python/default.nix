{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
}:

buildPythonPackage rec {
  pname = "todoist-api-python";
  version = "2.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Xi3B/Nl5bMbW0lYwrkEbBgFTEl07YkFyN18kN0WyGyw=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/Doist/todoist-api-python/pull/81
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/Doist/todoist-api-python/commit/42288e066d2f0c69611ab50cb57ca98b8c6bd1ca.patch";
      hash = "sha256-yq+VVvjPYywvUn+ydyWVQPkiYPYWe9U6w38G54L2lkE=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "todoist_api_python" ];

  meta = with lib; {
    description = "Library for the Todoist REST API";
    homepage = "https://github.com/Doist/todoist-api-python";
    changelog = "https://github.com/Doist/todoist-api-python/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
