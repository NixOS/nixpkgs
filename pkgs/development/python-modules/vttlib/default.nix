{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  fonttools,
  pyparsing,
  ufolib2,
  ufo2ft,
}:

buildPythonPackage rec {
  pname = "vttlib";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = "vttLib";
    rev = "v${version}";
    hash = "sha256-m6oxJj6JEKo3HUMfKNIqHwOHNpuCkA0R8ZrY5HLsiKc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    pyparsing
    ufolib2
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ufo2ft
  ];

  pythonImportsCheck = [ "vttLib" ];

  meta = {
    description = "Dump, merge and compile Visual TrueType data in UFO3 with FontTools";
    homepage = "https://github.com/daltonmaag/vttLib";
    changelog = "https://github.com/daltonmaag/vttLib/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
