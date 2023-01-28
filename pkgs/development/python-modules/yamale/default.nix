{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pyyaml
, ruamel-yaml
}:

buildPythonPackage rec {
  pname = "yamale";
  version = "4.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = pname;
    rev = version;
    sha256 = "sha256-1GFvgfy3MDsJGKSEm0yaQoLM7VqIS2wphw16trNTUOc=";
  };

  propagatedBuildInputs = [
    pyyaml
    ruamel-yaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "yamale"
  ];

  meta = with lib; {
    description = "A schema and validator for YAML";
    homepage = "https://github.com/23andMe/Yamale";
    license = licenses.mit;
    maintainers = with maintainers; [ rtburns-jpl ];
  };
}
