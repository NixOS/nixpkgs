{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gitUpdater,
  setuptools,
  setuptools-scm,
  fonttools,
  ufolib2,
}:

buildPythonPackage rec {
  pname = "ufomerge";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googlefonts";
    repo = "ufomerge";
    rev = "refs/tags/${version}";
    hash = "sha256-0izeb2PeGIYbzzQ+/K0Dz/9fVWFcPizQI39X/EQF5bU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    ufolib2
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Command line utility and Python library that merges two UFO source format fonts into a single file";
    homepage = "https://github.com/googlefonts/ufomerge";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
}
