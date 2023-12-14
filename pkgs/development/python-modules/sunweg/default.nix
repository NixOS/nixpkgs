{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "sunweg";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rokam";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-S92PybN+pReI9WtJr9as95uceicsSMadMQfh9JxsE8U=";
  };

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
