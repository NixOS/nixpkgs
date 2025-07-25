{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  maison,
  pdm-backend,
  pytest-freezegun,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  ruyaml,
  setuptools,
  writableTmpDirAsHomeHook,
}:
let
  maison143 = maison.overridePythonAttrs (old: rec {
    version = "1.4.3";
    src = fetchFromGitHub {
      owner = "dbatten5";
      repo = "maison";
      tag = "v${version}";
      hash = "sha256-2hUmk91wr5o2cV3un2nMoXDG+3GT7SaIOKY+QaZY3nw=";
    };
  });
in

buildPythonPackage rec {
  pname = "yamlfix";
  version = "1.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lyz-code";
    repo = "yamlfix";
    tag = version;
    hash = "sha256-RRpU6cxb3a3g6RrJbUCxY7YC87HHbGkhOFtE3hf8HdA=";
  };

  build-system = [
    setuptools
    pdm-backend
  ];

  dependencies = [
    click
    maison143
    ruyaml
  ];

  pythonRelaxDeps = [ "maison" ];

  nativeCheckInputs = [
    pytest-freezegun
    pytest-xdist
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "yamlfix" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  meta = {
    description = "Python YAML formatter that keeps your comments";
    homepage = "https://github.com/lyz-code/yamlfix";
    changelog = "https://github.com/lyz-code/yamlfix/blob/${version}/CHANGELOG.md";
    mainProgram = "yamlfix";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ koozz ];
  };
}
