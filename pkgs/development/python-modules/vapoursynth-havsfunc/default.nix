{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  vapoursynth,
  vsjetpack,
}:

buildPythonPackage {
  pname = "havsfunc";
  version = "33-unstable-2025-06-1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "havsfunc";
    rev = "aa79ebc9eb5517a3a76a74caa98a9d41993ac39b";
    hash = "sha256-HI9TeWQT8JBYdLLJC5eQmaDORO5CZRsZfF+GjKldhTc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    vapoursynth
    vsjetpack
  ];

  pythonRelaxDeps = [ "vapoursynth" ];

  meta = {
    description = "Holy's ported AviSynth functions for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/havsfunc";
    changelog = "https://github.com/HomeOfVapourSynthEvolution/havsfunc/releases";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
