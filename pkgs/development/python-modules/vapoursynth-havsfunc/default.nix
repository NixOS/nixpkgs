{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  vapoursynth,
  vsdenoise,
  vsexprtools,
  vsmasktools,
  vsrgtools,
  vstools,
}:

buildPythonPackage {
  pname = "havsfunc";
  version = "33.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "havsfunc";
    rev = "8707846664a692108c579780e27061ca593559f8";
    hash = "sha256-BYcjfKHv5qgN2mjIg3jzuck0lYzTy25WvrO7S40oZdc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    vapoursynth
    vsdenoise
    vsexprtools
    vsmasktools
    vsrgtools
    vstools
  ];

  pythonRelaxDeps = [ "vapoursynth" ];

  meta = {
    description = "Holy's ported AviSynth functions for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/havsfunc";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
