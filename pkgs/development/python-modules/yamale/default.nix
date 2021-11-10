{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, pyyaml
, ruamel_yaml
}:

buildPythonPackage rec {
  pname = "yamale";
  version = "4.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = pname;
    rev = version;
    sha256 = "sha256-hFBU3o3HpL0Schgzcx3oYq0IAUVGKThIfEteYcFbLnk=";
  };

  propagatedBuildInputs = [
    pyyaml
    ruamel_yaml
  ];

  checkInputs = [
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
