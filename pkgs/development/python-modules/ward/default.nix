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
    rev = "refs/tags/release%2F${version}";
    hash = "sha256-4dEMEEPySezgw3dIcYMl56HrhyaYlql9JvtamOn7Y8g=";
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

  meta = with lib; {
    description = "Test framework for Python";
    homepage = "https://github.com/darrenburns/ward";
    changelog = "https://github.com/darrenburns/ward/releases/tag/release%2F${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ward";
    # Old requirements (cucumber-tag-expressions and rich)
    # https://github.com/darrenburns/ward/issues/380
    broken = versionAtLeast rich.version "13.0.0";
  };
}
