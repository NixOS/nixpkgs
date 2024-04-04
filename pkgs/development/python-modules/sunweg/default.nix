{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "sunweg";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rokam";
    repo = "sunweg";
    rev = "refs/tags/${version}";
    hash = "sha256-fgNtxCBIuNulCfuDaEsM7kL1WpwNE9O+JQ1DMZrz5jA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sunweg"
  ];

  meta = with lib; {
    description = "Module to access the WEG solar energy platform";
    homepage = "https://github.com/rokam/sunweg";
    changelog = "https://github.com/rokam/sunweg/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
