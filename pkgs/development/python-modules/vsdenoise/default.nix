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
  vsmasktools,
  vsaa,
  vsscale,
}:

buildPythonPackage rec {
  pname = "vsdenoise";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-denoise";
    rev = "refs/tags/v${version}";
    hash = "sha256-CRxc8xakQbIGx/3TOF9G8JIbyMckn3QWOTth6QJ21LA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    vapoursynth
    vstools
    vskernels
    vsexprtools
    vsrgtools
    vsmasktools
    vsaa
    vsscale
  ];

  meta = {
    description = "VapourSynth denoising, regression, and motion-compensation functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-denoise";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
