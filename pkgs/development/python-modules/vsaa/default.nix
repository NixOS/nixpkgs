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
}:

buildPythonPackage rec {
  pname = "vsaa";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-aa";
    rev = "refs/tags/v${version}";
    hash = "sha256-KAZvdra1faoTDKJls7JMi5ds6jqY5wIh/xmKj8IaW50=";
  };

  build-system = [ setuptools ];

  dependencies = [
    vapoursynth
    vstools
    vskernels
    vsexprtools
    vsrgtools
    vsmasktools
  ];

  meta = {
    description = "VapourSynth anti aliasing and scaling functions";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
