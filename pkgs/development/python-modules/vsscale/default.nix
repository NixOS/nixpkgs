{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  vsmasktools,
  vsaa,
}:

buildPythonPackage rec {
  pname = "vsscale";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-scale";
    rev = "refs/tags/v${version}";
    hash = "sha256-eCOP2jUAWYIgnsFoWpXlXy3/0/9ZPOoq69iH3lIcn0M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    vsmasktools
    vsaa
  ];

  meta = {
    description = "VapourSynth (de)scale functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-scale";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
