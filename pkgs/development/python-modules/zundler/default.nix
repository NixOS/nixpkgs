{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lxml,
  nox,
  pytest-docker,
  pytest-selenium,
  pytestCheckHook,
  python-magic,
  selenium,
  sphinx,
}:

buildPythonPackage rec {
  pname = "zundler";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AdrianVollmer";
    repo = "Zundler";
    tag = version;
    hash = "sha256-RUzVeJLRB9y6lS0tCkseoFgND1MXT7s2o7vNuUpdRDE=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    lxml
    python-magic
    sphinx
  ];

  nativeCheckInputs = [
    nox
    pytestCheckHook
    pytest-docker
    pytest-selenium
    selenium
  ];

  # Tests are container-based
  doCheck = false;

  pythonImportsCheck = [ "zundler" ];

  meta = {
    description = "Bundle assets of distributed HTML docs into one self-contained HTML file";
    homepage = "https://github.com/AdrianVollmer/Zundler";
    changelog = "https://github.com/AdrianVollmer/Zundler/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
