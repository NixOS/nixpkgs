{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  pyyaml,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yamale";
  version = "5.2.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = "yamale";
    rev = "refs/tags/${version}";
    hash = "sha256-UTtase1b8Zjaixhp/g0tLtT6QZS4cyaSHcFz+h9Qoos=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yamale" ];

  meta = with lib; {
    description = "A schema and validator for YAML";
    homepage = "https://github.com/23andMe/Yamale";
    changelog = "https://github.com/23andMe/Yamale/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ rtburns-jpl ];
    mainProgram = "yamale";
  };
}
