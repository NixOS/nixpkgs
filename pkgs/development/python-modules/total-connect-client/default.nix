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
  version = "2023.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "craigjmidwinter";
    repo = "total-connect-client";
    rev = "refs/tags/${version}";
    hash = "sha256-BZEL/cIAeiwxQor3TbzY8cJ08PYSkXxMl/4XkIEXncg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    zeep
  ];

  checkInputs = [
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
