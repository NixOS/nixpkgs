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
  version = "4.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = pname;
    rev = version;
    sha256 = "sha256-EkCKUSPRrj3g2AY17tquBDxf+nWfpdnILu5AS/2SsLo=";
  };

  propagatedBuildInputs = [
    pyyaml
    ruamel-yaml
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
