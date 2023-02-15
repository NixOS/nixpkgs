{ lib
, attrs
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, poetry-core
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, responses
}:

buildPythonPackage rec {
  pname = "todoist-api-python";
  version = "2.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Doist";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-CKOsUb35+7WjSNf4Xo0SK5loIqWJbEnHdmhw9QXWFAI=";
  };

  patches = [
    # Switch to poetry-core, https://github.com/Doist/todoist-api-python/pull/81
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/Doist/todoist-api-python/commit/42288e066d2f0c69611ab50cb57ca98b8c6bd1ca.patch";
      sha256 = "sha256-yq+VVvjPYywvUn+ydyWVQPkiYPYWe9U6w38G54L2lkE=";
    })
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "todoist_api_python"
  ];

  meta = with lib; {
    description = "Library for the Todoist REST API";
    homepage = "https://github.com/Doist/todoist-api-python";
    changelog = "https://github.com/Doist/todoist-api-python/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
