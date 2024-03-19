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
  version = "5.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-T//hmZNVU6zDBaX/79KjdZwaReI4v73Ny7uQGKQREiI=";
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
    mainProgram = "yamale";
    homepage = "https://github.com/23andMe/Yamale";
    license = licenses.mit;
    maintainers = with maintainers; [ rtburns-jpl ];
  };
}
