{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  setuptools-scm,
  fonttools,
  pyparsing,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "vttlib";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daltonmaag";
    repo = "vttLib";
    rev = "v${version}";
    hash = "sha256-ChsuzeFRQFDYGlAE4TWzE+et7yGLOfha1VqGcOdayOs=";
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

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Dump, merge and compile Visual TrueType data in UFO3 with FontTools";
    homepage = "https://github.com/daltonmaag/vttLib";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
