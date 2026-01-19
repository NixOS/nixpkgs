{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.29";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WoItB14XQXk07Trdb8ebX8j7VE/kNwsviUzdKPDd144=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "striprtf" ];

  meta = {
    changelog = "https://github.com/joshy/striprtf/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/joshy/striprtf";
    description = "Simple library to convert rtf to text";
    mainProgram = "striprtf";
    maintainers = with lib.maintainers; [ aanderse ];
    license = with lib.licenses; [ bsd3 ];
  };
}
