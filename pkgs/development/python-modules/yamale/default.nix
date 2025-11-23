{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyyaml,
  ruamel-yaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "yamale";
  version = "6.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = "yamale";
    tag = version;
    hash = "sha256-+UZJhZLJEZVGPF9D9B8blGh4pLszQnDoOl5xQMpvVl0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
  ];

  optional-dependencies = {
    ruamel = [ ruamel-yaml ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.ruamel;

  pythonImportsCheck = [ "yamale" ];

  meta = with lib; {
    description = "Schema and validator for YAML";
    homepage = "https://github.com/23andMe/Yamale";
    changelog = "https://github.com/23andMe/Yamale/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ rtburns-jpl ];
    mainProgram = "yamale";
  };
}
