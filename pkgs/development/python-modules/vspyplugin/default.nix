{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,

  vapoursynth,
  vstools,
  vsexprtools,
}:

buildPythonPackage rec {
  pname = "vspyplugin";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-pyplugin";
    rev = "refs/tags/v${version}";
    hash = "sha256-amaSB1PX2PLPeawCcTwHNo9O/wPeagHEScRsVgLG06E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    vapoursynth
    vstools
    vsexprtools
  ];

  pythonImportsCheck = [ "vspyplugin" ];

  doCheck = false; # no tests

  meta = {
    description = "RgTools and related functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-pyplugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
