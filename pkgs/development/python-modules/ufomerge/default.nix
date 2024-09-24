{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonRelaxDepsHook,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  fonttools,
  fontfeatures,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "ufomerge";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "ufomerge";
    rev = "refs/tags/v${version}";
    hash = "sha256-Bo/KJhJTIAGNDT2QoXRKGMYLQuqjfCe5yaCsFcQ4A64=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "fonttools" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    ufolib2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    fontfeatures
  ];

  disabledTestPaths = [
    # Failing due to fonttools being to old
    "tests/test_layout.py"
  ];

  pythonImportsCheck = [ "ufomerge" ];

  meta = {
    description = "Command line utility and Python library that merges two UFO source format fonts into a single file";
    homepage = "https://github.com/googlefonts/ufomerge";
    changelog = "https://github.com/googlefonts/ufomerge/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
