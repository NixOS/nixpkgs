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
  version = "1.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "ufomerge";
    tag = "v${version}";
    hash = "sha256-5nTxcZeBClui7ceeq6sIOaoK8x0L6sBWqmhXr0On4Eg=";
  };

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

  disabledTests = [
    # Fails with `KeyError: 'B'`
    "test_28"
  ];

  pythonImportsCheck = [ "ufomerge" ];

  meta = {
    description = "Command line utility and Python library that merges two UFO source format fonts into a single file";
    homepage = "https://github.com/googlefonts/ufomerge";
    changelog = "https://github.com/googlefonts/ufomerge/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
