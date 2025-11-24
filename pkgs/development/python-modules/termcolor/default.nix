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
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-am3X++5YGQnu7Gp1bP8df3w3YGOxTkopjcSYAwnlWXA=";
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
