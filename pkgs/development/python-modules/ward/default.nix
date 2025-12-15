{
  lib,
  buildPythonPackage,
  click,
  click-completion,
  click-default-group,
  cucumber-tag-expressions,
  fetchFromGitHub,
  pluggy,
  poetry-core,
  pprintpp,
  pythonOlder,
  rich,
  tomli,
}:

buildPythonPackage rec {
  pname = "ward";
  version = "0.68.0b0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "darrenburns";
    repo = "ward";
    tag = "release%2F${version}";
    hash = "sha256-Qc209wGrBk5rPWR6vS17w9aQyydU6U/8QBD85LbJWV0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    click
    rich
    tomli
    pprintpp
    cucumber-tag-expressions
    click-default-group
    click-completion
    pluggy
  ];

  # Fixture is missing. Looks like an issue with the import of the sample file
  doCheck = false;

  pythonImportsCheck = [ "ward" ];

  meta = {
    description = "Test framework for Python";
    homepage = "https://github.com/darrenburns/ward";
    changelog = "https://github.com/darrenburns/ward/releases/tag/release%2F${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ward";
    # Old requirements (cucumber-tag-expressions and rich)
    # https://github.com/darrenburns/ward/issues/380
    broken = lib.versionAtLeast rich.version "13.0.0";
  };
}
