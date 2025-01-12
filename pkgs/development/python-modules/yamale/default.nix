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
  version = "5.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = "yamale";
    tag = version;
    hash = "sha256-fYH+0OUJ9EnsAQh/VUOUVms1jwqpcLBj/c5uLj/1gVc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    ruamel-yaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "yamale" ];

  meta = with lib; {
    description = "Schema and validator for YAML";
    homepage = "https://github.com/23andMe/Yamale";
    changelog = "https://github.com/23andMe/Yamale/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ rtburns-jpl ];
    mainProgram = "yamale";
  };
}
