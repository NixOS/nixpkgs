{
  lib,
  anyio,
  buildPythonPackage,
  dirty-equals,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
  tenacity,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "stamina";
  version = "25.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "stamina";
    tag = version;
    hash = "sha256-TehGqR3vbjLNByHZE2+Ytq52dpEpiL6+7TRUKwXcC1M=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    tenacity
    typing-extensions
  ];

  nativeCheckInputs = [
    anyio
    dirty-equals
    pytestCheckHook
  ];

  pythonImportsCheck = [ "stamina" ];

  meta = with lib; {
    description = "Production-grade retries for Python";
    homepage = "https://github.com/hynek/stamina";
    changelog = "https://github.com/hynek/stamina/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
