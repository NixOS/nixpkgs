{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "striprtf";
  version = "0.0.29";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WoItB14XQXk07Trdb8ebX8j7VE/kNwsviUzdKPDd144=";
  };

  build-system = [ hatchling ];

  pythonImportsCheck = [ "striprtf" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "https://github.com/joshy/striprtf/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/joshy/striprtf";
    description = "Simple library to convert rtf to text";
    mainProgram = "striprtf";
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ aanderse ];
    license = with lib.licenses; [ bsd3 ];
=======
    maintainers = with maintainers; [ aanderse ];
    license = with licenses; [ bsd3 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
