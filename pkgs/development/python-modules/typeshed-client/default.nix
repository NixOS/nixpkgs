{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-resources
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "typeshed-client";
  version = "2.5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JelleZijlstra";
    repo = "typeshed_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-lITreXYn/ZOc1fF2Sqcn8UDrZAjWYfjFSEaAxqTHb4s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "typeshed_client"
  ];

  pytestFlagsArray = [
    "tests/test.py"
  ];

  meta = with lib; {
    description = "Retrieve information from typeshed and other typing stubs";
    homepage = "https://github.com/JelleZijlstra/typeshed_client";
    changelog = "https://github.com/JelleZijlstra/typeshed_client/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
