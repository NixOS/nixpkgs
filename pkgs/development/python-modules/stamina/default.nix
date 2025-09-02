{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,

  tenacity,
  typing-extensions,

  anyio,
  dirty-equals,
  pytestCheckHook,
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

  nativeBuildInputs = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    tenacity
    typing-extensions
  ];

  pythonImportsCheck = [ "stamina" ];

  nativeCheckInputs = [
    pytestCheckHook
    anyio
    dirty-equals
  ];

  meta = with lib; {
    description = "Production-grade retries for Python";
    homepage = "https://github.com/hynek/stamina";
    changelog = "https://github.com/hynek/stamina/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
