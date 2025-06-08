{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  rich,
  scipy,
  jetpytools,
  vapoursynth,
  vapoursynth-akarin,
  vapoursynth-zip,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "vsjetpack";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-jetpack";
    tag = "v${version}";
    hash = "sha256-AKaZaHvQJRhAfYxGiT7xehjeQEU1P2kAcvXwUrixCCo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    rich
    scipy
    jetpytools
  ];

  propagatedBuildInputs = [
    # not sure if this works properly
    vapoursynth-akarin
    vapoursynth-zip
  ];

  pythonImportsCheck = [
    "vstools"
    "vskernels"
    "vsexprtools"
    "vsrgtools"
    "vsmasktools"
    "vsaa"
    "vsscale"
    "vsdenoise"
    "vsdehalo"
    "vsdeband"
    "vsdeinterlace"
    "vssource"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    (vapoursynth.withPlugins propagatedBuildInputs)
  ];

  meta = {
    description = "Filters, wrappers, and helper functions for filtering video using VapourSynth";
    homepage = "https://jaded-encoding-thaumaturgy.github.io/vs-jetpack/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
