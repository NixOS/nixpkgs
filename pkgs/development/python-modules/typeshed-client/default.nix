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
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "JelleZijlstra";
    repo = "typeshed_client";
    rev = "refs/tags/v${version}";
    hash = "sha256-g3FECKebKeM3JPWem6+Y9T27PcAxVxj1SiBd5siLSJ4=";
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
