{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
, zeep
}:

buildPythonPackage rec {
  pname = "total-connect-client";
  version = "2024.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    rev = "refs/tags/${version}";
    hash = "sha256-LuPyhidbAzt/AU5WuXyxggGxjm9yArHsbn6iAaccMEc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    zeep
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "total_connect_client"
  ];

  meta = with lib; {
    description = "Interact with Total Connect 2 alarm systems";
    homepage = "https://github.com/craigjmidwinter/total-connect-client";
    changelog = "https://github.com/craigjmidwinter/total-connect-client/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
