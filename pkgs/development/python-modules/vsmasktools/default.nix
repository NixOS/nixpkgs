{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  vapoursynth,
  vstools,
  vskernels,
  vsexprtools,
  vsrgtools,
  vapoursynth-tcanny,
  vapoursynth-tedgemask,
  vapoursynth-awarpsharp2,
  warpsharp,
}:

buildPythonPackage rec {
  pname = "vsmasktools";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-masktools";
    rev = "refs/tags/v${version}";
    hash = "sha256-xa/BHOqpWISLzWz12q+fN/EWZIMHleUe9kMPjO6/214=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    vapoursynth-tcanny
    vapoursynth-tedgemask
    vapoursynth-awarpsharp2
    warpsharp
  ];

  dependencies = [
    vapoursynth
    vstools
    vskernels
    vsexprtools
    vsrgtools
  ];

  meta = {
    description = "Various masking tools for VapourSynth";
    homepage = "https://vsmasktools.encode.moe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
