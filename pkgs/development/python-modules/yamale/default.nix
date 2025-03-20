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
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "23andMe";
    repo = "yamale";
    tag = version;
    hash = "sha256-Ij9jhGMYHUStZ/xR5GUg/eF6YQdtIfpLU7g1pev6wJU=";
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
