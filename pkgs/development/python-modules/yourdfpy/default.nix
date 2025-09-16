{
  lib,

  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  lxml,
  trimesh,
  numpy,
  six,

  # nativeCheckInputs
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "yourdfpy";
  version = "0.0.58";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clemense";
    repo = "yourdfpy";
    tag = "v${version}";
    hash = "sha256-Wi4QcgTOf/1nXWssFtlyRxql8Jg1nNKjEGkWuP+w73g=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lxml
    trimesh
    numpy
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "yourdfpy"
  ];

  meta = {
    description = "Python parser for URDFs";
    homepage = "https://github.com/clemense/yourdfpy/";
    changelog = "https://github.com/clemense/yourdfpy/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "yourdfpy";
  };
}
