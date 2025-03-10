{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  vapoursynth,
  stgpytools,
  rich,
}:

buildPythonPackage rec {
  pname = "vstools";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-XqPIh2iTxcIU3o8XIrsE1o4B8D/YkP7nlJB40woG+so=";
  };

  build-system = [ setuptools ];

  dependencies = [
    vapoursynth
    stgpytools
    rich
  ];

  pythonImportsCheck = [
    "vstools"
    "vstools.enums"
    "vstools.exceptions"
    "vstools.functions"
    "vstools.types"
    "vstools.utils"
  ];

  doCheck = false; # no tests

  meta = {
    description = "Functions and utils related to VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
