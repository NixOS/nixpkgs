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
}:

buildPythonPackage (finalAttrs: {
  pname = "stamina";
  version = "26.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "stamina";
    tag = finalAttrs.version;
    hash = "sha256-3cCaYAoWPriynITcMnWn1WndXP2gLro/0ba/87hrnIk=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    tenacity
  ];

  nativeCheckInputs = [
    anyio
    dirty-equals
    pytestCheckHook
  ];

  pythonImportsCheck = [ "stamina" ];

  meta = {
    description = "Production-grade retries for Python";
    homepage = "https://github.com/hynek/stamina";
    changelog = "https://github.com/hynek/stamina/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
