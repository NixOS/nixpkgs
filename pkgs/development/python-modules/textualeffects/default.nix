{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  terminaltexteffects,
}:

buildPythonPackage rec {
  pname = "textualeffects";
  version = "0.1.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hnCTIdSc16v0ftUTeCEwF05vXYXqFplqfDhwnDZGxGM=";
  };

  build-system = [ hatchling ];

  dependencies = [ terminaltexteffects ];

  pythonImportsCheck = [ "textualeffects" ];

  # no tests implemented
  doCheck = false;

  meta = {
    description = "Visual effects for Textual, a TerminalTextEffects wrapper";
    homepage = "https://github.com/ggozad/textualeffects";
    changelog = "https://github.com/ggozad/textualeffects/blob/v${version}/CHANGES.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
  };
}
