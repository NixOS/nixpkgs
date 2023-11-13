{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.14.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alecthomas";
    repo = "voluptuous";
    rev = "refs/tags/${version}";
    hash = "sha256-xUVKh9IqOIiZNrGSG87KDQffcBDRMTb1hyfC1OvKK0c=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "voluptuous"
  ];

  pytestFlagsArray = [
    "voluptuous/tests/"
  ];

  meta = with lib; {
    description = "Python data validation library";
    homepage = "http://alecthomas.github.io/voluptuous/";
    changelog = "https://github.com/alecthomas/voluptuous/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
