{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "termcolor";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DNhVyHFjg/FSrQK7s5hB1uRpRTj/XUJAiOVsi4H95SU=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "termcolor" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/termcolor/termcolor/releases/tag/${version}";
    description = "ANSI color formatting for output in terminal";
    homepage = "https://github.com/termcolor/termcolor";
    license = licenses.mit;
  };
}
