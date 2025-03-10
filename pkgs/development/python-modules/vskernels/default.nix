{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  vapoursynth,
  vstools,
}:

buildPythonPackage rec {
  pname = "vskernels";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-kernels";
    rev = "refs/tags/v${version}";
    hash = "sha256-os/01zGqfHBXI2pkUQU2rJl5H18Eg9ttaGakYBoPb8k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    vapoursynth
    vstools
  ];

  pythonImportsCheck = [
    "vskernels"
    "vskernels.kernels"
  ];

  doCheck = false; # no tests

  meta = {
    description = "Kernel objects for scaling and format conversion within VapourSynth";
    homepage = "https://vskernels.encode.moe/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
