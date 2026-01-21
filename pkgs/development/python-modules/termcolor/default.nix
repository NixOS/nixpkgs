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
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NIhxymSOxqmpg6E6tibArM4C9RW54ZgzMrF695eVIcU=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "termcolor" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/termcolor/termcolor/releases/tag/${version}";
    description = "ANSI color formatting for output in terminal";
    homepage = "https://github.com/termcolor/termcolor";
    license = lib.licenses.mit;
  };
}
