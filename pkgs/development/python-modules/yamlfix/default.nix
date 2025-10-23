{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  maison,
  pdm-backend,
  pydantic,
  pytest-freezegun,
  pytest-xdist,
  pytestCheckHook,
  ruyaml,
  setuptools,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "yamlfix";
  version = "1.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = "yamlfix";
    tag = version;
    hash = "sha256-g2X9fBUS5wbQJbP29V5pWwrQ1+P/Y8euK4Rv7C6r3WM=";
  };

  build-system = [
    setuptools
    pdm-backend
  ];

  dependencies = [
    click
    maison
    pydantic
    ruyaml
  ];

  nativeCheckInputs = [
    pytest-freezegun
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "yamlfix" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    "-Wignore::ResourceWarning"
  ];

  meta = {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ koozz ];
    mainProgram = "yamlfix";
  };
}
