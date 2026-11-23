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

buildPythonPackage rec {
  pname = "stamina";
  version = "26.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "stamina";
    tag = version;
    hash = "sha256-lwE9bxGPy/AI5uxPJ4DL3EuO43t2pOLJ5jZIg/8+31Y=";
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
    changelog = "https://github.com/hynek/stamina/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
