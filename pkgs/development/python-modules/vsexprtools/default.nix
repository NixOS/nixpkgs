{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  vapoursynth,
  vstools,
}:

buildPythonPackage rec {
  pname = "vsexprtools";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vs-exprtools";
    rev = "refs/tags/v${version}";
    hash = "sha256-Gdw7ObFQnGmE6rTQJbZ0BG/tXnl2xumhXLwV+/eQOpE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    vapoursynth
    vstools
  ];

  pythonImportsCheck = [
    "vsexprtools"
    "vsexprtools.polyfills"
  ];

  doCheck = false; # no tests

  meta = {
    description = "VapourSynth functions and helpers for writing RPN expressions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-exprtools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
